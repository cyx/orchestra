module Orchestra
  class Configuration
    def initialize
      @configuration = {
        'table' => {
          'host' => 'localhost',
          'port' => 1978
        },

        'hash' => {
          'host' => 'localhost',
          'port' => 1979
        },

        'storage_engine' => 'Edo'
      }
    end

    def []( *args )
      case args.size
      when 1
        @configuration[args.first.to_s]
      when 2
        @configuration[args.first.to_s][args.last.to_s]
      else
        raise ArgumentError, "Config[] accepts only up to 2 parameters"
      end
    end

    def storage_engine
      Storage.const_get(self['storage_engine'])
    end
  end

  Config = Configuration.new
end
