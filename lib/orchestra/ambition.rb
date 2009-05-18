module Orchestra
  module Ambition
    autoload :Context,       'orchestra/ambition/context'
    autoload :Condition,     'orchestra/ambition/condition'

    def self.included( base )
      base.extend ClassMethods
    end

    module ClassMethods
      def select( &block )
        context = Context.new
        context.__prepare__(self, db)
        yield context
        context
      end
    end
  end
end
