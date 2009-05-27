require 'orchestra/data_space'
require 'orchestra/tokyo'
require 'orchestra/ambition'

class Session
  include Orchestra::DataSpace
  include Orchestra::Tokyo
  include Orchestra::Ambition
end
