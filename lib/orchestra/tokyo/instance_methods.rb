module Orchestra
  module Tokyo
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
      alias :reload :refresh

      def delete
        self.class.delete( id )
      rescue
        return false
      else
        return true
      end
      alias :destroy :delete

      def inspect
        "#<#{self.class.name} id:#{id}, attrs: #{attributes.inspect}>"
      end
      alias :to_s :inspect

      def ==( other_model )
        self.id and self.id == other_model.id
      end
    end
  end
end
