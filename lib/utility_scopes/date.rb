#TODO: use base_class to get rid off duplication?
module UtilityScopes
  module Date
    
    def self.included(base)
      base.extend ClassMethods
      
      base.class_eval do
        # Provide a before date scope
        scope(:before, lambda { |*args|
          { :conditions => ["#{args.flatten[0]} < ?", args.flatten[1]] }
        })
        
        scope(:after, lambda { |*args|
          { :conditions => ["#{args.flatten[0]} > ?", args.flatten[1]] }
        })
        
        scope(:on, lambda { |*args|
          { :conditions => {args.flatten[0] => args.flatten[1]} }
        })
              
        scope :between, lambda { |*args| { :conditions => ["#{args.flatten[0].to_s} BETWEEN ? AND ?", args.flatten[1], args.flatten[2]] } }
        
        scope :created_between, lambda { |start_at, end_at| { :conditions => ["created_at BETWEEN ? AND ?", start_at, end_at] } }
                
        scope :today, lambda { |*args| { :conditions => ["#{args.empty? ? 'created_at' : args.flatten[0].to_s} BETWEEN ? AND ?", Time.current.beginning_of_day, Time.current.end_of_day] } }
        
        class << self
          # Set alias on
          alias_method :at, :on
        end
      end
    end
    
    module ClassMethods
      
      # Allow things like these:
      #   @post.created_before(1.day.ago)
      #   @post.created_between(1.month.ago, 15.days.ago)
      
      # If chaining with other named scope for some reason this has to be specified first
      #   @post.comments.recent.created_between(x, y)  -- doesn't work
      #   @post.comments.created_between(x, y).recent -- works
      #   @post.comments.recent.between(:created_at, x, y) -- works
      
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
        when col = method.to_s.match(/^(.*)(_today)$/)[1] rescue false
          if col = self.columns.find{|c| c.type == :datetime && c.name.match(/^#{col}(_at|_on)$/) }.name rescue false
            return self.today(col)
          else
            super
          end
        else
          super
        end
      end
      
      private
      
      def eigenclass; class << self; self end; end
    end
  end
end
