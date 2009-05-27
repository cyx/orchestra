module Orchestra
  module Tokyo
    module ClassMethods
      def post( attributes = {} )
        if uid = db.generate_unique_id
          put( uid, attributes )
        else
          raise Error, Error::UID_GEN
        end
      end
      alias :create :post

      def put( uid, attributes = {} )
        attrs = sanitize_attributes(attributes_with_meta( attributes ))
        begin
          db[id(uid)] = attrs
        rescue Exception => e
          raise Error, sprintf( Error::PUT, attrs.inspect, e )
        end

        model = new( attrs.merge( :pk => uid ) )
      end
      alias :update :put

      def get( uid )
        if attributes = db_slave[id(uid)]
          model = new( attributes.merge( :pk => uid ) )
        end
      end
      alias :find :get

      def delete( uid )
        begin
          db.delete( id(uid) )
        rescue Exception => e
          raise Error, sprintf(Error::DELETE, uid)
        end
      end
      alias :destroy :delete

      def delete_all
        db.clear
      end

      def size
        db_slave.size
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

      def sanitize_attributes( attributes )
        attrs = {}
        attributes.each do |field, value|
          attrs[field.to_s] = value.to_s
        end
        attrs
      end

      def db
        Connection[self, 'master']
      end

      def db_slave
        Connection[self, 'slave'] || db
      end

      def id( uid )
        uid.to_s
      end
    end
  end
end
