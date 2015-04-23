require "yaml"
require "pathname"
require 'hashie'

module Sleek
  module Config
    extend self

    def application
      Hashie::Mash.new(load_yaml_config)
    end

    def redis
      application.redis
    end

    private

    def load_yaml_config
      path = Pathname.new(File.join(__dir__, "../config/application.yml")).expand_path
      file = File.read(path)
      config = YAML.load(file)[env]
    end

    def env
      ENV["RACK_ENV"] || "development"
    end
  end
end
