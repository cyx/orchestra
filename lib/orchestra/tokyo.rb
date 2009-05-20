module Orchestra
  module Tokyo
    autoload :Error,           'orchestra/tokyo/error'
    autoload :ClassMethods,    'orchestra/tokyo/class_methods'
    autoload :InstanceMethods, 'orchestra/tokyo/instance_methods'

    def self.included( base )
      base.extend ClassMethods
      base.send :include, InstanceMethods
    end
  end
end
