require "json"
class HomeAction < Cramp::SSE

  keep_connection_alive
  on_start :events
  on_finish :close_redis_connection

  def events
    channels = [:message, :task]
    pubsub = redis.pubsub(channels)

    channels.each do |channel|
      pubsub.on(channel) { |channel, message|
        data = format_data(message, channel)
        render data.to_json, event: data[:type]
      }
    end
  end


  def close_redis_connection
    redis.connection.on(:disconnected) do
      puts 'Iam disconnected'
    end
    redis.close
  end

  private
  def redis
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

end
