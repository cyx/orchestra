require 'uri'
require 'forwardable'

module Orchestra
  class Connection
    # Usage: 
    # - Orchestra::Connection['User', 'master'].table
    # - Orchestra::Connection['User', 'slave'].table
    def self.[]( model_name, role, index = nil )
      uris = [ Config['connections'][ model_name.to_s ][ role ] ].compact.flatten

      return if uris.empty?

      if index
        uri = uris[index]
      else
        uri, index = balance( key(model_name, role), uris )
      end

      Thread.current[key(model_name, role, index)] ||=
        Storage.table( *host_and_port_for(uri) )
    end

    def self.host_and_port_for( url )
      uri = URI.parse( canonical_uri( url ) )
      return uri.host, uri.port 
    end

    protected
    def self.key( *args )
      args.map { |a| a.to_s }.join('/')
    end

    def self.balance( key, uris )
      balancing[key] += 1 
      balancing[key] = balancing[key] % uris.size
      return uris[balancing[key]], balancing[key]
    end

    def self.balancing
      Thread.current[ "OrchestraBalancing " ] ||= Hash.new { |h, k| h[k] = -1 }
    end

    def self.canonical_uri( uri )
      uri.match(/^http:\/\//) ? uri : "http://#{uri}"
    end
  end
end
