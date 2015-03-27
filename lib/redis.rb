module Sleek
  class Redis

    def initialize
      @redis = client 
    end

    def pubsub(channels)
      pubsub = @redis.pubsub
      channels.each do |channel|
        pubsub.subscribe(channel).callback { puts "Subscribed" }
      end
      pubsub
    end

    def publish(key, data)
      @redis.publish(key, data)
    end

    def connection
      @redis
    end

    def close
      @redis.close_connection
    end

    private
    def client
       EM::Hiredis.connect(Config.redis.url) 
    end

  end

end
