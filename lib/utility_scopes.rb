require 'utility_scopes/date'
require 'utility_scopes/without'
require 'utility_scopes/pks'

module UtilityScopes
  def self.included(base)
    base.class_eval do
      include UtilityScopes::Date
      include UtilityScopes::Without
      include UtilityScopes::Pks
    end
  end
end

# if defined?(ActiveRecord)
#
#   ActiveRecord::Base.class_eval do
#     include UtilityScopes::Date
#     include UtilityScopes::Without
#     include UtilityScopes::Pks
#     include UtilityScopes::Deleted
#   end
#
# end

ActiveRecord::Base.send :include, UtilityScopes
