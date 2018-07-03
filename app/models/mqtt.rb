class Mqtt
  def self.create_user(username, password)
    response = faraday_conn.post do |req|
      req.url 'api/user'
      req.headers['Content-Type'] = 'application/json'
      req.body = { username: username, password: password }.to_json
    end
    raise "#{response.status}: #{response.body}" unless response.status == 204
  end

  def self.delete_user(username)
    response = faraday_conn.delete do |req|
      req.url "api/user/#{username}"
      req.headers['Content-Type'] = 'application/json'
    end
    raise "#{response.status}: #{response.body}" unless response.status == 204
  end

  def self.update_password(username, password)
    response = faraday_conn.post do |req|
      req.url "api/user/#{username}"
      req.headers['Content-Type'] = 'application/json'
      req.body = { password: password }.to_json
    end
    raise "#{response.status}: #{response.body}" unless response.status == 204
  end

  def self.grant_topic_access(username, topic)
    faraday_conn.post do |req|
      req.url 'api/acl'
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        "type": 'topic',
        "pattern": topic,
        "username": username,
        "read": false, "write": true
      }.to_json
    end
    raise "#{response.status}: #{response.body}" unless response.status == 204
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
    # conn.basic_auth(api_key, '')
    conn
  end
end
