# -*- encoding : utf-8 -*-
require 'spec_helper'

class Scripter::IterationHistoryTestable
  include Scripter::IterationHistory
  attr_accessor :use_cache
end

class Scripter::IterationHistoryTestable2
  include Scripter::IterationHistory
  attr_accessor :use_cache
end

describe Scripter::IterationHistory do
  before(:each) do
    @it = Scripter::IterationHistoryTestable.new
    @it.use_cache = true
  end

  it "should be able to set custom cache store" do
    @it.cache_store = 'My custom cache_store'
    expect(@it.cache_store).to eq 'My custom cache_store'
  end

  describe "#iteration_processed! and #iteration_processed?" do
    it "should share cache between instances of the same class" do
      expect(@it.iteration_processed?(1)).to be false

      another_it = Scripter::IterationHistoryTestable.new
      another_it.iteration_processed!(1)

      expect(@it.iteration_processed?(1)).to be true
    end

    it "should not share cache between instances of different classes" do
      expect(@it.iteration_processed?(1)).to be false

      another_class_it = Scripter::IterationHistoryTestable2.new
      another_class_it.use_cache = true
      another_class_it.iteration_processed!(1)

      expect(another_class_it.iteration_processed?(1)).to be true
      expect(@it.iteration_processed?(1)).to be false
    end

    it "should remember results for 24 hours" do
      @it.iteration_processed!(1)
      expect(@it.iteration_processed?(1)).to be true

      Timecop.travel(Time.now + 24.hours) do
        expect(@it.iteration_processed?(1)).to be false
      end
    end

    it "should be different for different iteration_id" do
      expect(@it.iteration_processed?(1)).to be false
      expect(@it.iteration_processed?(2)).to be false
      @it.iteration_processed!(1)
      expect(@it.iteration_processed?(1)).to be true
      expect(@it.iteration_processed?(2)).to be false
    end

    it "should always be unprocessed if #use_cache is false" do
      @it.use_cache = false
      expect(@it.iteration_processed?(1)).to be false
      @it.iteration_processed!(1)
      expect(@it.iteration_processed?(1)).to be false
    end
  end

end
