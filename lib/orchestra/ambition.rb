require 'forwardable'

module Orchestra
  module Ambition
    autoload :ClassMethods,  'orchestra/ambition/class_methods'
    autoload :Iterator,      'orchestra/ambition/iterator'
    autoload :ElementProxy,  'orchestra/ambition/element_proxy'
    autoload :Condition,     'orchestra/ambition/condition'
    autoload :Sorter,        'orchestra/ambition/sorter'
    autoload :Slicer,        'orchestra/ambition/slicer'

    def self.included( model )
      model.extend ClassMethods
    end
  end
end
