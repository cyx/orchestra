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
      
      attr_reader :index

      def initialize( model, uri, role, index = nil )
        @model, @role, @index = model, role, index
        @uri                  = URI.parse("http://#{uri.gsub('http://', '')}")
      end

      def sid
        @sid ||= [ @model, @role, @index ].compact.join('-')
      end
    end

    class ClusterInformation < Struct.new(:model, :masters, :slaves)
      def each
        if slaves.size % masters.size != 0
          raise "Error with Configuration of #{model}: Make sure the # of slaves is divisible by the number of masters (i.e. 6 slaves, 3 masters, 1 slave, 1 master)"
        end
        
        if masters.size > 2
          raise "Error with Configuration or #{model}: Orchestra only supports 2 masters"
        end

        modulo = slaves.size / masters.size
        
        masters.each_with_index do |master, idx|
          yield master, slaves.select { |s| s.index / modulo == idx }, masters[idx - 1]
        end
      end
    end

    def clusters
      self['connections'].map do |model, roles|
        ret = { 'master' => [], 'slave' => [] }

        roles.each do |role, uris|
          uris = [ uris ].flatten
          uris.each_with_index do |uri, idx|
            ret[role] << ConnectionInformation.new( model, uri, role, idx )
          end
        end
          
        ClusterInformation.new( model, ret['master'], ret['slave'] )
      end
    end
  end

  Config = Configuration.new
end
