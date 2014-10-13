# -*- encoding : utf-8 -*-
require 'logger'

module Scripter
  module Logger

    attr_writer :logger
    def logger
      @logger ||= ::Logger.new(STDOUT)
    end

    def log(type, message)
      logger.send(type, message)
    end

    def log_title(message)
      log :info, "--------------------------------------------------------------------"
      log :info, "|     #{message}"
      log :info, "--------------------------------------------------------------------"
    end

    def log_error(error)
      log :error, "\n ----------------------------- #{error.fetch(:message)} -----------------------------"
      log :error, "#{error.fetch(:category)} \n"
      log :error, "-------------------------------------------------------------------- \n"
    end

  end
end
