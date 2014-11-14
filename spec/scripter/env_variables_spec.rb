# -*- encoding : utf-8 -*-
require 'spec_helper'

class Scripter::EnvVariablesTestable
  include Scripter::EnvVariables
  env_variables :rails_env, :countries, :use_cache, :report_date

  # custom type casts test
  def type_cast_env_variable(name, value)
    if name == :countries
      value.split(/\s*,\s*/)
    elsif name == :report_date
      value.nil? ? Date.today : value
    else
      super
    end
  end
end

describe Scripter::EnvVariables do
  before(:each) do
    @it = Scripter::EnvVariablesTestable.new
  end

  describe "::env_variables" do
    it "should be available" do
      expect(@it.class.respond_to?(:env_variables)).to be true
    end

    it "should be able to add new Environment variable getters" do
      expect(@it.respond_to?(:test_variable)).to be false
      @it.class.send :env_variables, :test_variable
      expect(@it).to receive(:raw_env_variables).and_return({test_variable: 'something'})
      expect(@it.test_variable).to eq 'something'
    end
  end

  context "with stubbed arguments" do
    before(:each) do
      expect(@it).to receive(:command_line_arguments).and_return(['notifications', 'RAILS_ENV=test', 'COUNTRIES=LV,EE,FI', 'use_cache=1'])
    end

    it { expect(@it.rails_env).to eq 'test' }
    it { expect(@it.countries).to eq ['LV', 'EE', 'FI'] }
    it { expect(@it.use_cache).to eq true }
    it { expect(@it.report_date).to eq Date.today }

  end

  describe "#type_cast_env_variable" do
    it ":date should be date or nil" do
      expect(@it.type_cast_env_variable(:date, nil)).to be_nil
      expect(@it.type_cast_env_variable(:date, '2014-04-14')).to eq Date.new(2014, 4, 14)
    end

    [:dry_run, :force_run, :use_cache].each do |variable_name|
      it ":#{variable_name} should be boolean" do
        expect(@it.type_cast_env_variable(variable_name, nil)).to be false
        expect(@it.type_cast_env_variable(variable_name, '')).to be false
        expect(@it.type_cast_env_variable(variable_name, '1')).to be true
      end
    end
  end

  it "#command_line_arguments should return ARGV" do
    expect(@it.send(:command_line_arguments)).to be ARGV
  end

end
