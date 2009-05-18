module Orchestra
  module Ambition
    class Condition
      attr_accessor :name, :operator, :value, :affirmative, :no_index

      def initialize( name, operator = nil, value = nil)
        @name, @operator, @value = name, operator, value

        @affirmative, @no_index = true, true
      end

      def not
        @affirmative = false
        self
      end

      OPERATORS = {
        :== => :equals,
        :>= => :gte,
        :>  => :gt,
        :<= => :lte,
        :<  => :lt,
        :=~ => :regex,
        :include?     => :includes,
        :starts_with? => :starts_with,
        :ends_with?   => :ends_with
      }

      OPERATORS.each do |method, operator|
        define_method method do |value|
          self.operator = operator
          self.value    = value
        end
      end
    end
  end
end
