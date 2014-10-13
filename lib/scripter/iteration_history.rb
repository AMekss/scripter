# -*- encoding : utf-8 -*-
module Scripter
  module IterationHistory

    attr_writer :cache_store
    def cache_store
      @cache_store ||= Scripter::CacheStore.new
    end

    def iteration_processed!(iteration_item_id)
      return if iteration_item_id.to_s.empty?
      cache_store.write(calculate_cache_key(iteration_item_id), true, expires_in: 24 * 3600)
    end

    def iteration_processed?(iteration_item_id)
      return false unless use_cache
      !!cache_store.read(calculate_cache_key(iteration_item_id))
    end

private

    def calculate_cache_key(iteration_item_id)
      "#{self.class}_#{iteration_item_id}"
    end

  end
end
