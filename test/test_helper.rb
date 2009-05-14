require 'bacon'
require File.join(File.dirname(__FILE__), '..', 'lib', 'orchestra')

Dir[ File.dirname(__FILE__) + '/fixtures/**/*.rb' ].each { |f| require f }
