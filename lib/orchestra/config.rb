require 'yaml'
require 'forwardable'
require 'uri'

module Orchestra
  class Configuration
    def initialize
      @configuration = YAML.load_file( Orchestra.root + '/config/clustering.yml' )
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
    
    class ConnectionInformation
      extend Forwardable
      
      def_delegators :@uri, :host, :port

      def initialize( model, uri, role, index = nil )
        @model, @role, @index = model, role, index
        @uri                  = URI.parse("http://#{uri.gsub('http://', '')}")
      end

      def sid
        @sid ||= [ @model, @role, @index ].compact.join('-')
      end
    end

    class ClusterInformation < Struct.new(:model, :master, :slaves)
    end

    def clusters
      self['connections'].map do |model, roles|
        master = ConnectionInformation.new( model, roles['master'], 'master' )
        slaves = []
        roles['slave'].each_with_index do |slave, idx|
          slaves << ConnectionInformation.new( model, slave, 'slave', idx )
        end

        ClusterInformation.new( model, master, slaves )
      end
    end
  end

  Config = Configuration.new
end
