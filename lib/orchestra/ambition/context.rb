module Orchestra
  module Ambition
    class Context < Orchestra::BlankSlate
      def __prepare__( klass, db )
        @klass     = klass
        @db        = db
        @query   ||= Storage.table_query( @db )
        @fields    = [ Condition.new('_class', :equals, klass) ]
        @sorting   = []
        @slicing   = nil
      end

      def size
        size = __results__( :pk_only => true ).size
        __results__.free
        size
      end

      def sort_by
        yield  Orchestra::Ambition::Sorter.new( @sorting )
        return self
      end

      def select
        yield  self
        return self
      end

      def detect
        yield  self
        return first
      end

      def slice( offset, limit )
        @slicing = [ offset, limit ]
        return self
      end

      def first( limit = nil )
        if limit
          slice( 0, limit )
        else
          slice( 0, 1 )
          to_a.first
        end
      end

      def any?
        yield  self if block_given?
        return first != nil
      end
      
      def empty?
        @klass.size.zero?
      end
      
      def all?
        yield  self
        return self.size == @klass.size
      end

      def to_a
        arr = __results__.to_a
        __results__.free
        arr.map { |a| @klass.new(a) }
      end
      alias :entries :to_a

      private
      def method_missing( method, *args )
        @fields << Condition.new( method )
        @fields.last
      end

      def __results__( args = {} )
        pk_only, no_pk = args[:pk_only], args[:no_pk]

        return @__results__ if @__results__

        @fields.each do |field|
          @query.add( field.name.to_s, field.operator, field.value.to_s, field.affirmative, field.no_index )
        end

        @sorting.each do |field, direction|
          @query.order_by( field.to_s, (direction || :asc).to_sym )
        end

        if @slicing
          @query.limit( @slicing.last, @slicing.first )
        end

        @query.pk_only if pk_only
        @query.no_pk   if no_pk

        @__results__ = @query.run
        @query.free
        @__results__
      end
    end
  end
end
