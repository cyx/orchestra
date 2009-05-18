require 'orchestra/data_space'
require 'orchestra/tokyo'
require 'orchestra/ambition'

class User
  include Orchestra::DataSpace
  include Orchestra::Tokyo
  include Orchestra::Ambition
end
