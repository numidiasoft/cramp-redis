require "bundler/setup"

require_relative "../application"

def event_machine_wrap(&example)
  EM.run do
    example.call
  end
end

RSpec.configure do |c|
  c.around(:example) { |ex| event_machine_wrap(&ex) }
  c.expect_with :rspec
  c.order = :random
end
