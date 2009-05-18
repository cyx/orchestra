require 'bacon'
require File.join(File.dirname(__FILE__), '..', 'lib', 'orchestra')

Dir[ File.dirname(__FILE__) + '/fixtures/**/*.rb' ].each { |f| require f }

class Array
  def contain?( other_array )
    self.all? { |e| other_array.include?(e) }
  end

  def same?( other_array )
    self.size == other_array.size && contain?( other_array )
  end
  alias :equal? :same?
  alias :eql?   :same?
  alias :==     :same?

  def second
    self[1]
  end

  def third
    self[2]
  end

  def fourth
    self[3]
  end
end
