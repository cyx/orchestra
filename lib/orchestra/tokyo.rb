require 'rufus/tokyo/tyrant'

module Orchestra
  module Tokyo
    def self.included( base )
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end

    module ClassMethods
      def post( attributes = {} )
        meta[:size] = meta[:size] + 1

        if uid = db.generate_unique_id
          put( uid, attributes )
        else
          raise Error, Error::UID_GEN
        end
      end

      def put( uid, attributes = {} )
        attrs = attributes_with_meta( attributes )
        begin
          db[id(uid)] = attrs
        rescue Exception => e
          raise Error, sprintf( Error::PUT, attrs.inspect, e )
        end

        model = new( attrs.merge( :pk => uid ) )
      end

      def get( uid )
        if attributes = db[id(uid)]
          model = new( attributes.merge( :pk => uid ) )
        end
      end

      def delete( uid )
        begin
          db.delete( id(uid) )
        rescue Exception => e
          raise Error, sprintf(Error::DELETE, uid)
        else
          meta[:size] = meta[:size] - 1
        end
      end

      def size
        meta[:size]
      end

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
        @db ||= Rufus::Tokyo::TyrantTable.new( 'localhost', 1978 )
      end

      def id( uid )
        "#{self.name}:#{uid}"
      end

      def meta
        @meta ||= Meta.new( self )
      end
    end

    module InstanceMethods
      def save
        self.class.put( id, attributes )
      rescue
        return false
      else
        return true
      end

      def refresh
        model = self.class.get( id )
        self.attributes = model.attributes
      end

      def delete
        self.class.delete( id )
      rescue
        return false
      else
        return true
      end
    end
  end
end
