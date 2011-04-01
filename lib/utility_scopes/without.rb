module UtilityScopes
  module Without

    def self.included(within)
      within.class_eval do

        # Give every class the ability to add to itself the without named
        # scope
        extend ClassMethods

        # And automatically do so for all its subclasses
        def self.inherited_with_without_scope_hook(child)
          inherited_without_without_scope_hook(child)
          child.attach_without_utility_scope
        end
        class << self
          alias_method_chain :inherited, :without_scope_hook
        end
      end
    end

    module ClassMethods

      # Must be a class method called directly on AR::Base subclasses
      # so scope knows who its base class, and thus, table_name
      # and primary_key are.
      def attach_without_utility_scope

        # Allow easy rejection of items.
        # Can take an a single id or ActiveRecord object, or an array of them
        # Example:
        #   before   Article.all.reject{|a| a == @bad_article }
        #   after    Article.without(@bad_article)
        scope :without, lambda { |item_or_list|
          # nil or empty array causes issues here with mysql
          item_or_list.blank? ? {} : {:conditions => ["#{quoted_table_name}.#{primary_key} NOT IN (?)", item_or_list]}
        }
      end
    end
  end
end
