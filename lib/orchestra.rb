module Orchestra

end

Dir[ File.join( File.dirname(__FILE__), 'orchestra', '**', '*.rb' ) ].each { |rb| require rb }
