# -*- encoding : utf-8 -*-
module Scripter
  class Base
    include Scripter::Errors
    include Scripter::Logger
    include Scripter::EnvVariables
    include Scripter::IterationHistory

    env_variables :use_cache, :dry_run, :force_run

    def self.set_custom_executable_name(name)
      class_eval %{
        def self.#{name}
          self.execute(:#{name})
        end
      }
    end

    def initialize
      yield self if block_given?
      self
    end

    def self.execute(iteration_function_name=:execute)
      self.new do |scripter_instance|
        # exits immediately without raising an exception on ctrl+c
        trap("SIGINT") { exit! }

        scripter_instance.with_fault_monitoring do
          scripter_instance.instance_variable_set :@iteration_idx, 0
          scripter_instance.public_send(iteration_function_name)
        end

        scripter_instance.on_exit if scripter_instance.respond_to?(:on_exit)
      end
    end

    def with_fault_monitoring
      log :info, "==============================================   START   =============================================="
      begin
        log :info, "Performing: #{self.inspect}"
        yield
      rescue Exception => error
        add_error(error)
      ensure
        log :info, "===============================================   END   ==============================================="
      end
    end

    def perform_iteration(iteration_id, iteration_meta={}, verbose=true)
      @iteration_idx += 1
      begin
        unless iteration_processed?(iteration_id)
          yield
          iteration_processed!(iteration_id)
        end
      rescue Exception => error
        add_error(error, iteration_meta, verbose)
        if @iteration_idx == 100 && errors_count > 50
          raise "Iteration was interrupted as error rate was too big (#{errors_count.to_f / @iteration_idx.to_f * 100.0}%)"
        end
      end
    end
  end
end
