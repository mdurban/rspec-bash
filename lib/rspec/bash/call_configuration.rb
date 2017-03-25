require 'yaml'

module Rspec
  module Bash
    class CallConfiguration
      attr_reader :command

      def initialize(config_path, command)
        @config_path = config_path
        @configuration = []
        @command = command
      end

      def set_exitcode(exitcode, args = [])
        current_conf = create_or_get_conf(args)
        current_conf[:exitcode] = exitcode
        write
      end

      def add_output(content, target, args = [])
        current_conf = create_or_get_conf(args)
        current_conf[:outputs] << {
          target: target,
          content: content
        }
        write
      end

      def call_configuration
        return @configuration unless @configuration.empty?
        begin
          @config_path.open('r') do |conf_file|
            YAML.load(conf_file.read) || []
          end
        rescue NoMethodError, Errno::ENOENT
          return []
        end
      end

      def call_configuration=(new_conf)
        @configuration = new_conf
        write
      end

      private

      def write
        @config_path.open('w') do |conf_file|
          conf_file.write @configuration.to_yaml
        end
      end

      def create_or_get_conf(args)
        @configuration = call_configuration
        new_conf = {
          args: args,
          exitcode: 0,
          outputs: []
        }
        current_conf = @configuration.select { |conf| conf[:args] == args }
        @configuration << new_conf if current_conf.empty?
        current_conf.first || new_conf
      end
    end
  end
end
