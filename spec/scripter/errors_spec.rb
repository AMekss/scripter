# -*- encoding : utf-8 -*-
require 'spec_helper'

class Scripter::ErrorsTestable
  include Scripter::Errors
  include Scripter::Logger

  def raise_test_exception
    begin
      raise "test error"
    rescue Exception => e
      add_error(e, {}, false)
    end
  end

end

describe Scripter::Errors do
  before(:each) do
    @it = Scripter::ErrorsTestable.new
  end

  it "should provide errors array" do
    expect(@it).to respond_to(:errors)
    expect(@it.errors).to be_instance_of(Array)
  end

  it "should provide errors_grouped array groped by category" do
    @it.errors << {category: 'test category', message: 'test message'}
    @it.errors << {category: 'test category', message: 'test message1'}
    @it.errors << {category: 'test category', message: 'test message2'}
    @it.errors << {category: 'test category1', message: 'test message2'}

    expect(@it.respond_to?(:errors_grouped)).to be true
    expect(@it.errors_grouped).to be_instance_of(Hash)
    expect(@it.errors_grouped['test category'].size).to eq 3
  end

  it "#errors_count should return count of stored errors" do
    expect(@it.errors_count).to eq 0
    @it.errors << {category: 'test category', message: 'test message'}
    expect(@it.errors_count).to eq 1
    @it.errors << {category: 'test category', message: 'test message1'}
    expect(@it.errors_count).to eq 2
  end

  describe "#valid?" do
    it "should be true if no errors stored" do
      expect(@it.valid?).to be true
    end

    it "should be false if there are errors" do
      @it.errors << {category: 'test category', message: 'test message'}
      expect(@it.valid?).to be false
    end
  end

  describe "#invalid?" do
    it "should be false if no errors stored" do
      expect(@it.invalid?).to be false
    end

    it "should be true if there are errors" do
      @it.errors << {category: 'test category', message: 'test message'}
      expect(@it.invalid?).to be true
    end
  end

  describe "#add_error" do
    before(:each) do
      expect(@it.errors).to be_empty
      @errors_hash = {category: 'error', message: 'some'}
    end

    it "should be able to log incoming error if error_to_log is true" do
      expect(@it).to receive(:log_error).once.with(@errors_hash)
      @it.add_error(@errors_hash, {}, true)
      @it.add_error(@errors_hash, {}, false)
    end

    it "should add meta information to error if passed along" do
      @it.add_error(@errors_hash, {add: 'info'}, false)
      expect(@it.errors.first).to eq({category: 'error', message: 'some', add: 'info'})
    end

    it "should be able to add error from exception" do
      @it.raise_test_exception

      expect(@it.errors).not_to be_empty
      error = @it.errors.first
      expect(error[:message]).to eq 'test error'
      expect(error[:category]).to be_a Array
    end
  end

end
