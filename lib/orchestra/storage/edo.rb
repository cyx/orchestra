require 'rufus/edo/ntyrant'

module Orchestra
  module Storage
    class Edo
      def self.table( host, port )
        Rufus::Edo::NetTyrantTable.new( host, port )
      end

      def self.hash( host, port )
        Rufus::Edo::NetTyrant.new( host, port )
      end

      def self.table_query( db )
        Rufus::Edo::TableQuery.new( TokyoTyrant::RDBQRY, db )
      end
    end
  end
end
