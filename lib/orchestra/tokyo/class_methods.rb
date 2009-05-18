module Orchestra
  module Tokyo
    module ClassMethods
      def post( attributes = {} )
        meta[:size] = meta[:size] + 1

        if uid = db.generate_unique_id
          put( uid, attributes )
        else
          raise Error, Error::UID_GEN
        end
      end
      alias :create :post

      def put( uid, attributes = {} )
        attrs = attributes_with_meta( attributes )
        begin
          db[id(uid)] = attrs
        rescue Exception => e
          raise Error, sprintf( Error::PUT, attrs.inspect, e )
        end

        model = new( attrs.merge( :pk => uid ) )
      end
      alias :update :put

      def get( uid )
        if attributes = db[id(uid)]
          model = new( attributes.merge( :pk => uid ) )
        end
      end
      alias :find :get

      def delete( uid )
        begin
          db.delete( id(uid) )
        rescue Exception => e
          raise Error, sprintf(Error::DELETE, uid)
        else
          meta[:size] = meta[:size] - 1
        end
      end
      alias :destroy :delete

      def delete_all
        db.delete_keys_with_prefix( self.name )
        meta[:size] = 0
      end

      def size
        meta[:size]
      end
      alias :count :size

      protected
      def attributes_with_meta( attributes )
        defaults = {
          '_rev' => (Time.now.utc.to_f * 1000).to_i.to_s,
          '_class' => self.name,
          'updated_at' => Time.now.utc.to_i.to_s
        }
        defaults['created_at'] = Time.now.utc.to_i.to_s unless attributes['created_at']
        (attributes || {}).merge( defaults )
      end

      def db
        @db ||= Orchestra::TableAdapter.new
      end

      def id( uid )
        "#{self.name}:#{uid}"
      end

      def meta
        @meta ||= Meta.new( self )
      end
    end
  end
end
