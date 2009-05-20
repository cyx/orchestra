module Orchestra
  autoload :Config,     'orchestra/config'
  autoload :Tokyo,      'orchestra/tokyo'
  autoload :Storage,    'orchestra/storage'
  autoload :BlankSlate, 'orchestra/blankslate'

  def self.root
    @root ||= File.join(File.dirname(__FILE__), '..')
  end
end

$LOAD_PATH.unshift( File.dirname(__FILE__) )
