require 'rufus/tokyo/tyrant'

module Orchestra
  module Storage
    class Tokyo
      def self.table( host, port )
        Rufus::Tokyo::TyrantTable.new( host, port )
      end

      def self.hash( host, port )
        Rufus::Tokyo::Tyrant.new( host, port )
      end

      def self.table_query( db )
        Rufus::Tokyo::TableQuery.new( db )
      end
    end
  end
end
