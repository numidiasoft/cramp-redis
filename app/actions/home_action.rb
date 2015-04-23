require "json"
class HomeAction < Cramp::SSE

  keep_connection_alive
  on_start :events
  on_finish :close_redis_connection

  def events
    puts @env.inspect
    sleek_redis.pubsub(channels)

    sleek_redis.on_message do |channel, message|
      data = format_data(message, channel)
      puts data.inspect
      render data.to_json, event: data[:type]
    end
  end

  def close_redis_connection
    sleek_redis.connection.on(:disconnected) do
      puts 'Iam disconnected'
    end
    sleek_redis.close
  end

  private
  def sleek_redis
    @redis ||= Sleek::Redis.new
  end

  def format_data(message, channel)
    begin
      json_message = JSON.parse(message)
      data = { message: message, channel: channel, type: json_message.keys.first }
    rescue JSON::ParserError => e
      { message: message, type: "message", channel: channel }
    end
  end

  def channels
    Sleek::Config.redis.channels.map.map do |channel|
      "events:#{channel}:#{params[:scope]}"
    end
  end

end
