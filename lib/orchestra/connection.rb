require 'uri'
require 'forwardable'

module Orchestra
  class Connection
    @@balancing = Hash.new { |h, k| h[k] = -1 }

    # Usage: 
    # - Orchestra::Connection['User', 'master'].table
    # - Orchestra::Connection['User', 'slave'].table

    def self.[]( model_name, role )
      case role
      when 'master'
        uri = Config['connections'][ model_name.to_s ][ role ]
        Thread.current[key(model_name, role)] ||= 
          Storage.table( *host_and_port_for( uri ) )
      when 'slave'
        uris = [ Config['connections'][model_name.to_s][role] ].compact.flatten
        if uris.any?
          uri, index  = balance( key(model_name, role), uris )
          Thread.current[key(model_name, role, index)] ||= 
            Storage.table( *host_and_port_for( uri ) )
        end
      end
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
      @@balancing[ key ] += 1 
      @@balancing[ key ] = @@balancing[key] % uris.size
      return uris[@@balancing[ key ]], @@balancing[key]
    end

    def self.canonical_uri( uri )
      uri.match(/^http:\/\//) ? uri : "http://#{uri}"
    end
  end
end
