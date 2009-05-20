module Orchestra
  module Storage
    autoload :Tokyo,    'orchestra/storage/tokyo'
    autoload :Edo,      'orchestra/storage/edo'

    @@engine = Config.adapter

    def self.table( klass )
      @@engine.table( Config.host( klass ), Config.port( klass ) )
    end
  end
end
