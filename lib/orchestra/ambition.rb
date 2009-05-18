module Orchestra
  module Ambition
    def self.included( base )
      base.extend ClassMethods
    end

    class Context < Orchestra::BlankSlate
      def __prepare__( db )
        @db = db
        @query = Rufus::Tokyo::TableQuery.new( @db )
      end

      class Field < Struct.new( :name, :operator, :value )
        def ==( value )
          self.operator = :equals
          self.value = value
        end

        def >=( value )
          self.operator = :gte
          self.value = value
        end

        def >( value )
          self.operator = :gt
          self.value = value
        end
      end

      def initialize
        @fields = []
      end

      def size
        __results__.size
      end

      private
      def method_missing( method, *args )
        @fields << Field.new( method )
        @fields.last
      end

      def __results__
        @fields.each do |field|
          @query.add( field.name.to_s, field.operator, field.value.to_s )
        end
        rs = @query.run
        @query.free
        rs
      end
    end

    module ClassMethods
      def select( &block )
        context = Context.new
        context.__prepare__(db)
        yield context
        context
      end
    end
  end
end
