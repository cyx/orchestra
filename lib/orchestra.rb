module Orchestra
  autoload :Config,     'orchestra/config'
  autoload :Tokyo,      'orchestra/tokyo'
  autoload :Storage,    'orchestra/storage'
  autoload :BlankSlate, 'orchestra/blankslate'
end

$LOAD_PATH.unshift( File.dirname(__FILE__) )
