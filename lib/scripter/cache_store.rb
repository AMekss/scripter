# -*- encoding : utf-8 -*-
require 'active_support'

module Scripter
  class CacheStore
    def initialize
      @cache = defined?(Rails) ? Rails.cache : ActiveSupport::Cache.lookup_store(:file_store, 'tmp/cache')
    end

    def read(*args)
      @cache.read(*args)
    end

    def write(*args)
      @cache.write(*args)
    end
  end
end
