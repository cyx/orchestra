module Orchestra
  module Storage
    autoload :Tokyo,    'orchestra/storage/tokyo'
    autoload :Edo,      'orchestra/storage/edo'

    @@engine = Config.adapter

    def self.table( host, port )
      @@engine.table( host, port )
    end
  end
end
