# -*- encoding : utf-8 -*-
module Scripter
  module Errors

    def errors
      @errors ||= []
    end

    def errors_grouped
      @errors_grouped ||= errors.group_by{|err| err[:category] }
    end

    def errors_count
      errors.count
    end

    def valid?
      errors.empty?
    end

    def invalid?
      !valid?
    end

    def add_error(error, meta_hash={}, error_to_log=true)
      error_hash = normalize_error(error)
      log_error(error_hash) if error_to_log
      errors << error_hash.merge(meta_hash)
    end

private

    def normalize_error(error)
      error.is_a?(Hash) ? error : { message: error.to_s, category: error.backtrace }
    end

  end
end
