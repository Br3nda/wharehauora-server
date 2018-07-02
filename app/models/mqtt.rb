class Mqtt
  def self.fetch_mqtt_user_list
    response = faraday_conn.get do |req|
      req.url 'user'
      req.headers['Content-Type'] = 'application/json'
    end

    JSON.parse(response.body)
  end

  def self.sync_mqtt_users
    fetch_mqtt_user_list.each do |record|
      user = User.find_by(email: record['username'])
      home = Home.find_by(owner: user)

      # make a record of this mqtt user
      mqtt_user = MqttUser.find_by(username: record['username'])
      mqtt_user = MqttUser.new(username: record['username']) unless mqtt_user
      mqtt_user.home = home

      # link to our own user record
      mqtt_user.save!
    end
  end

  def self.provision_user(username, password)
    faraday_conn.post do |req|
      req.url 'user'
      req.headers['Content-Type'] = 'application/json'
      req.body = { username: username, password: password }.to_json
    end
  end

  def self.grant_access(username, topic)
    body = {
      "type": 'topic',
      "pattern": topic,
      "read": false,
      "write": true,
      "username": username
    }

    faraday_conn.post do |req|
      req.url 'api/acl'
      req.headers['Content-Type'] = 'application/json'
      req.body = body.to_json
    end
  end

  def self.url
    'https://api.cloudmqtt.com'
  end

  def self.mqtt_api_creds
    URI.parse(ENV['CLOUDMQTT_URL'])
  end

  def self.faraday_conn
    creds = mqtt_api_creds
    conn = Faraday.new(url: url)
    conn.basic_auth(creds.user, creds.password)
    conn
  end
end
