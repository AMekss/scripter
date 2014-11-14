# -*- encoding : utf-8 -*-
module Scripter
  module EnvVariables

    def self.included(receiver)
      receiver.extend ClassMethods
    end

    module ClassMethods
      def env_variables(*variables)
        variables.each do |env_variable|
          class_eval %{
            def #{env_variable}
              @env_variables ||= {}
              @env_variables.fetch(:#{env_variable}) do
                @env_variables[:#{env_variable}] = type_cast_env_variable(:#{env_variable}, raw_env_variables[:#{env_variable}])
              end
            end
          }
        end
      end
    end

    def raw_env_variables
      @raw_env_variables ||= begin
        raw_env_variables = command_line_arguments.select{|arg| arg.include?('=')}.map do |arg|
          key, value = arg.split("=")
          nomalized_key = key.downcase.to_sym
          [nomalized_key, value]
        end
        Hash[raw_env_variables]
      end
    end

    # You can override this method in order to add additional typecasts for custom params,
    # but don't forget to call super in else block of your switch statement
    def type_cast_env_variable(name, value)
      case name
      when :date
        ::Date.parse(value, false) unless value.to_s.empty?
      when :dry_run, :force_run, :use_cache
        !value.to_s.empty?
      else
        value
      end
    end

private

    def command_line_arguments
      @command_line_arguments ||= ARGV
    end

  end
end
