module Orchestra
  module Tokyo
    class Meta < Struct.new( :namespace )
      def []=( key, value )
        hash[id(key)] = value.to_s
      end

      def [](key, coercion = :to_i)
        hash[id(key)].send( coercion )
      end

      private
      def id( key )
        "#{namespace}:#{key}"
      end

      def hash
        @hash ||= Rufus::Tokyo::Tyrant.new( 'localhost', 1979 )
      end
    end
  end
end
