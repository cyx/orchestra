module Orchestra
  module Ambition
    autoload :Context,       'orchestra/ambition/context'
    autoload :Condition,     'orchestra/ambition/condition'
    autoload :Sorter,        'orchestra/ambition/sorter'
    autoload :Slicer,        'orchestra/ambition/slicer'

    def self.included( base )
      base.extend ClassMethods
    end

    module ClassMethods
      METHODS = [ :select, :sort_by, :slice, :first, :any?, :all?, :empty? ]

      METHODS.each do |method|
        module_eval \
        <<-EOT
        def #{method}(&block)
          context.#{method}(&block)
        end
        EOT
      end

      protected
      def context
        context = Context.new
        context.__prepare__( self, db )
        context
      end
    end
  end
end
