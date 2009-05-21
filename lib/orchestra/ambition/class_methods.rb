module Orchestra
  module Ambition
    module ClassMethods
      extend Forwardable

      def_delegators :iterator, :select, :sort_by, :slice, :first, :any?, :all?, :empty?

      protected
      def iterator
        Iterator.new( self, db )
      end
    end
  end
end
