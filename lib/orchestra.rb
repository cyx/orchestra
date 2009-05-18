require 'rufus/edo/ntyrant'

module Orchestra
  autoload :Tokyo, 'orchestra/tokyo'

  class TableAdapter
    def self.new
      Rufus::Edo::NetTyrantTable.new( 'localhost', 1978 )
    end

    def self.query( db )
      Rufus::Edo::TableQuery.new( TokyoTyrant::RDBQRY, db )
    end
  end

  class HashAdapter
    def self.new
      Rufus::Edo::NetTyrant.new( 'localhost', 1979 )
    end
  end
end

$LOAD_PATH.unshift( File.dirname(__FILE__) )
