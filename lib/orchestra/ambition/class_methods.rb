module Orchestra
  module Ambition
    module ClassMethods
      extend Forwardable

      def_delegators :iterator, :select, :sort_by, :slice, :first, :any?, :all?, :empty?, :detect

      protected
      def iterator
        Iterator.new( self, db_slave )
      end
    end
  end
end
