# -*- encoding : utf-8 -*-
require 'spec_helper'

class Scripter::LoggerTestable
  include Scripter::Logger
end

describe Scripter::Logger do
  before(:each) do
    @it = Scripter::LoggerTestable.new
  end

  it "should be able to set custom logger" do
    @it.logger = 'My custom logger'
    expect(@it.logger).to eq 'My custom logger'
  end

  describe "#log" do
    it "should be available" do
      expect(@it.respond_to?(:log)).to be true
    end

    [:info, :debug, :error].each do |type|
      it "should be able to log #{type}" do
        expect(@it.logger).to receive(type).with('log message')
        @it.log type, 'log message'
      end
    end
  end

  describe "#log_title" do
    it "should be available" do
      expect(@it.respond_to?(:log_title)).to be true
    end

    it "should log title as info" do
      messages = []
      expect(@it).to receive(:log).exactly(3).times do |type, message|
        messages << message
        expect(type).to be :info
      end
      @it.log_title "test title"
      expect(messages.join.include?("test title")).to be true
    end
  end

  describe "#log_error" do
    it "should be available" do
      expect(@it.respond_to?(:log_error)).to be true
    end

    it "should log error message as error" do
      messages = []
      expect(@it).to receive(:log).exactly(3).times do |type, message|
        messages << message
        expect(type).to be :error
      end
      @it.log_error({category: "my test category", message: "my test message"})
      expect(messages.join.include?("my test category")).to be true
      expect(messages.join.include?("my test message")).to be true
    end
  end

end
