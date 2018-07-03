# frozen_string_literal: true

class Mqtt
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
