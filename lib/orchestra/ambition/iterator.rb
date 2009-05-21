module Orchestra
  module Ambition
    class Iterator
      def initialize( klass, db )
        @klass     = klass
        @db        = db
        @fields    = []
        @sorting   = []
        @slicing   = nil
      end

      def size
        query( :pk_only => true ).size
      end
      alias :length :size

      def sort_by
        yield  Sorter.new( @sorting )
        return self
      end

      def select
        yield  ElementProxy.new( @fields )
        return self
      end

      def detect
        yield  ElementProxy.new( @fields )
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
        yield  ElementProxy.new( @fields ) if block_given?
        return first != nil
      end

      def empty?
        !any?
      end

      def all?
        yield  ElementProxy.new( @fields )
        return self.size == @klass.size
      end

      def to_a
        query.map { |a| @klass.new(a) }
      end
      alias :entries :to_a

      def each
        to_a.each { |model| yield model }
      end

      private
      def query( args = {} )
        pk_only, no_pk = args[:pk_only], args[:no_pk]

        @query ||= @db.query do |q|
          @fields.each do |field|
            q.add( field.name.to_s,
                   field.operator,
                   field.value.to_s,
                   field.affirmative,
                   field.no_index
                   )
          end

          @sorting.each do |field, direction|
            q.order_by( field.to_s, (direction || :asc).to_sym )
          end

          if @slicing
            q.limit( @slicing.last, @slicing.first )
          end

          q.pk_only if pk_only
          q.no_pk   if no_pk
        end
      end
    end
  end
end
