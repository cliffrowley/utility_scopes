module UtilityScopes
  module Helpers
    
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods

      def safe_columns
        begin
          columns
        rescue ActiveRecord::StatementInvalid # If the table does not exist
          Array.new
        end
      end
      
      def safe_column_names
        safe_columns.collect(&:name)
      end

      def column_names_for_type(*types)
        safe_columns.select { |column| types.include? column.type }.collect(&:name)
      end

      def column_names_without_type(*types)
        safe_columns.select { |column| ! types.include? column.type }.collect(&:name)
      end

      def boolean_column_names
        column_names_for_type :boolean
      end

      def datetime_column_names
        column_names_for_type :datetime, :date
      end

      def text_and_string_column_names
        column_names_for_type :text, :string
      end

    end
  end
end