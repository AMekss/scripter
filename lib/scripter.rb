require 'scripter/version'
require 'scripter/cache_store'
require 'scripter/iteration_history'
require 'scripter/env_variables'
require 'scripter/logger'
require 'scripter/errors'
require 'scripter/base'

# Library for reducing of boilerplate in ruby scripts with possibility to run fault tolerant iterations, for example mass notifications, or support scripts
#
# Usage example:
# class MyScriptClass < Scripter::Base
#   #ENV variables which will be assigned to instance
#   env_variables :test_env
#
#   def execute
#     # your specific execution code goes here
#     # Note: use #perform_iteration helper with block in order to make fault tolerant iterations
#   end
#
#   def on_exit
#     # your reporting scripts goes here
#     # Note: #valid?, invalid?, #errors_grouped and #errors_count methods can be useful here
#   end
# end
#
# Call example:
# MyScriptClass.execute
#

module Scripter

end
