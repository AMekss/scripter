# -*- encoding : utf-8 -*-
require 'spec_helper'

class Scripter::BaseTestable < Scripter::Base
  env_variables :test_variable1, :test_variable2
  attr_reader :was_executed, :iteration_count
  def execute
    @was_executed = true
    @iteration_count = 0
  end
end

class Scripter::BaseTestableWithCustomName < Scripter::BaseTestable
  set_custom_executable_name :distribute
  def distribute
    @was_executed = true
  end
end

describe Scripter::Base do
  it "should have getters for to default environment variables" do
    expect(subject).to respond_to(:use_cache)
    expect(subject).to respond_to(:dry_run)
    expect(subject).to respond_to(:force_run)
  end

  it "should have Errors, Logger, EnvVariables and IterationHistory modules included" do
    expect(subject).to respond_to(:add_error)
    expect(subject).to respond_to(:log)
    expect(subject).to respond_to(:type_cast_env_variable)
    expect(subject).to respond_to(:cache_store)
  end

  it "should invoke instance method execute on execute class method call" do
    scripter = Scripter::BaseTestable.execute
    expect(scripter.was_executed).to be true
    expect(scripter).to respond_to(:test_variable1)
    expect(scripter).to respond_to(:test_variable2)
  end

  it "should be able to customize default iteration function name" do
    scripter = Scripter::BaseTestableWithCustomName.distribute
    expect(scripter.was_executed).to be true
  end

  context "errors handling" do
    class Scripter::BaseTestableWithErrors < Scripter::BaseTestable
      set_custom_executable_name :execute_with_global_error
      set_custom_executable_name :execute_with_iteration_error

      def execute_with_global_error
        execute
        raise "my global error"
      end

      def execute_with_iteration_error
        execute

        1000.times do |idx|
          perform_iteration(idx, {}, false) do
            @iteration_count += 1
            raise "my iteration error"
          end
        end
      end
    end

    before(:each) do
      @scripter_class = Scripter::BaseTestableWithErrors
    end

    it "should stop execution on global error" do
      scripter = @scripter_class.execute_with_global_error
      expect(scripter.was_executed).to be true
    end

    it "should continue execute only 100 times if there is an error in each execution loop" do
      scripter = @scripter_class.execute_with_iteration_error
      expect(scripter.was_executed).to be true
      expect(scripter.iteration_count).to eq 100
    end
  end

  context "EndToEnd test" do
    class Scripter::BaseTestableEndToEnd < Scripter::BaseTestable
      attr_reader :on_exit_was_called
      set_custom_executable_name :execute_with_loop

      def execute_with_loop
        execute

        10.times do |idx|
          perform_iteration(idx, {additional: 'info'}, false) do
            @iteration_count += 1
            raise "my iteration error nr #{idx}" if idx == 5
          end
        end
      end

      def on_exit
        @on_exit_was_called = true
      end
    end

    before(:each) do
      @scripter_class = Scripter::BaseTestableEndToEnd
    end

    it "should execute all iterations every time called" do
      scripter = @scripter_class.execute_with_loop
      expect(scripter.iteration_count).to eq 10
      scripter = @scripter_class.execute_with_loop
      expect(scripter.iteration_count).to eq 10
    end

    it "should execute only failed iterations if cache enabled" do
      allow_any_instance_of(@scripter_class).to receive(:use_cache).and_return(true)
      scripter = @scripter_class.execute_with_loop
      expect(scripter.iteration_count).to eq 10
      scripter = @scripter_class.execute_with_loop
      expect(scripter.iteration_count).to eq 1
    end

    it "should contain information about the failure including meta info" do
      scripter = @scripter_class.execute_with_loop
      error = scripter.errors.first
      expect(error[:message]).to eq 'my iteration error nr 5'
      expect(error[:additional]).to eq 'info'
      expect(error[:category]).to_not be_nil
    end

    it "should call on_exit if defined" do
      scripter = @scripter_class.execute_with_loop
      expect(scripter.on_exit_was_called).to be true
    end
  end

end
