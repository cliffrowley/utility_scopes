#TODO: use base_class to get rid off duplication?
module UtilityScopes
  module Date
    
    def self.included(base)
      base.extend ClassMethods
      
      base.class_eval do
        # Provide a before date scope
        named_scope(:before, lambda { |*args|
          { :conditions => ["#{args.flatten[0]} < ?", args.flatten[1]] }
        })
        
        named_scope(:after, lambda { |*args|
          { :conditions => ["#{args.flatten[0]} > ?", args.flatten[1]] }
        })
        
        named_scope(:on, lambda { |*args|
          { :conditions => {args.flatten[0] => args.flatten[1]} }
        })
              
        named_scope :between, lambda { |*args| { :conditions => ["? BETWEEN ? AND ?", args.flatten[0].to_s, args.flatten[1], args.flatten[2]] } }
        
        class << self
          # Set alias on
          alias_method :at, :on
        end
      end
    end
    
    module ClassMethods
      
      # Decorate this class with the ability to order itself in queries
      # either from a given parameter or from its default ordering:
      #
      #   class Article < ActiveRecord::Base
      #     ordered_by "published_at DESC"
      #   end
      #
      #   Article.ordered #=> all items ordered by "published_at DESC"
      #   Article.ordered('popularity ASC') #=> all items ordered by "popularity ASC"
      #   Article.default_ordering #=> "published_at DESC"
      #
      
      def method_missing(method, *args, &block)
        case
        when col = method.to_s.match(/^(.*)(_after)$/)[1] rescue false
          if col = self.columns.find{|c| c.type == :datetime && c.name.match(/^#{col}(_at|_on)$/) }.name rescue false
            return self.after(col, args.flatten.first)
          else
            super
          end
        when col = method.to_s.match(/^(.*)(_before)$/)[1] rescue false
          if col = self.columns.find{|c| c.type == :datetime && c.name.match(/^#{col}(_at|_on)$/) }.name rescue false
            return self.before(col, args.flatten.first)
          else
            super
          end
        when col = method.to_s.match(/^(.*)(_on|_at)$/)[1] rescue false
          if col = self.columns.find{|c| c.type == :datetime && c.name.match(/^#{col}(_at|_on)$/) }.name rescue false
            return self.on(col, args.flatten.first)
          else
            super
          end
        when col = method.to_s.match(/^(.*)(_between)$/)[1] rescue false
          if col = self.columns.find{|c| c.type == :datetime && c.name.match(/^#{col}(_at|_on)$/) }.name rescue false
            return self.between(col, args.flatten[0], args.flatten[1])
          else
            super
          end
        else
          super
        end
      end
      
      private
      
      def metaclass; class << self; self end; end
    end
  end
end
