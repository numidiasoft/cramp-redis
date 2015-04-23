require "spec_helper"
require "json"

RSpec.describe Sleek::Redis do

 let(:channels) { ["events:me:all"] }
 let(:redis) { Sleek::Redis.new }
 let(:message) { "Hello world" }

 describe "#pubsub" do
   after do
     EM.stop
   end

   it "returns pubsub" do
     pubsub = redis.pubsub(channels)
     expect(pubsub).to be_an_instance_of(EventMachine::Hiredis::PubsubClient)
   end
 end

 describe "#connection" do
   after do
     EM.stop
   end

   it "return a connection" do
     expect(redis.connection).to be_an_instance_of(EventMachine::Hiredis::Client)
   end
 end

 describe "#on_message" do
   it "suscribes to channels" do
     pubsub = redis.pubsub(channels)
     redis.on_message do |channels, message|
       @message =  message
     end

     EM.add_periodic_timer(1) {
       redis.publish(channels.first, message)
     }

     EM.add_timer(2) do
       expect(@message).to be_eql(message)
       EM.stop
     end
   end
 end

end
