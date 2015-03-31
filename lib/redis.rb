module Sleek
  class Redis

    def initialize
      @redis = client 
      @pubsub = @redis.pubsub
    end

    def pubsub(channels)
      channels.each do |channel|
        @pubsub.subscribe(channel).callback { puts "Subscribed to #{channel}" }
      end
      @pubsub
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
