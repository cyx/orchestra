module Orchestra
  module Storage
    autoload :Tokyo,    'orchestra/storage/tokyo'
    autoload :Edo,      'orchestra/storage/edo'

    @@engine = Config.storage_engine

    def self.table
      @@engine.table( Config[:table, :host], Config[:table, :port] )
    end

    def self.hash
      @@engine.hash( Config[:hash, :host], Config[:hash, :port] )
    end

    def self.table_query( db )
      @@engine.table_query( db )
    end
  end
end
