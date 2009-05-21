module Orchestra
  module Ambition
    class Sorter < Orchestra::BlankSlate
      attr_reader :sorting

      def initialize( sorting )
        @sorting = sorting
      end

      def method_missing( meth, *args )
        @sorting << [ meth.to_s, args.first ]
      end
    end
  end
end
