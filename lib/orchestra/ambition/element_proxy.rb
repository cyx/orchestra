module Orchestra
  module Ambition
    class ElementProxy < Orchestra::BlankSlate
      def initialize( fields )
        @fields = fields
      end

      private
      def method_missing( method, *args )
        @fields << Condition.new( method )
        @fields.last
      end
    end
  end
end
