require 'yaml'

module Orchestra
  class Configuration
    def initialize
      @configuration = YAML.load_file( Orchestra.root + '/config/clustering.yml' )
      @models = {}
      if @configuration['models'].is_a?(Array)
        @configuration['models'].each_with_index do |klass, index|
          @models[klass] = { 'index' => index }
        end
      elsif @configuration['models'].is_a?(Hash)
        @configuration['models'].each do |klass, settings|
          @models[klass] = settings
        end
      end
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

    def adapter
      Storage.const_get(self['adapter'])
    end

    def port( klass )
      starting_port + model( klass )['index']
    end

    def host( klass )
      model( klass )['host'] || 'localhost'
    end

    def models
      @mapping ||= @models.map do |klass, settings|
        { 'name' => klass.downcase }.merge( 'port' => port(klass), 'host' => host(klass) )
      end
    end

    private
    def starting_port
      self[:port].to_i
    end

    def model( klass )
      @models[ klass.to_s ] || raise(ArgumentError, "#{klass} doesn't appear to be a valid model of the system")
    end
  end

  Config = Configuration.new
end
