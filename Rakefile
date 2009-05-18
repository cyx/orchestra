desc "Run all the tests for the orchestra library"
task :test do
  cmd = "bacon #{Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].join(' ')}"
  puts `#{cmd}`
end

task :default => :test

namespace :orchestra do
  desc "Start a tokyo table and tokyo hash engine on ports 1978 and 1979"
  task :start do
    require 'fileutils'

    root  = File.join(File.dirname(__FILE__))
    tpath = 'tmp/table'
    hpath = 'tmp/hash'

    tport = 1978
    hport = 1979

    unless File.exist?( File.join(root, tpath) )
      puts "Creating #{tpath}"

      FileUtils.mkdir_p( File.join(root, tpath) )
    end

    unless File.exist?( File.join(root, hpath) )
      puts "Creating #{hpath}"

      FileUtils.mkdir_p( File.join(root, hpath) )
    end

    puts "Starting the TokyoTyrant server (for Table) on port #{tport}"
    `ttserver -port #{tport} -dmn -pid #{root}/#{tpath}/pid -log #{root}/#{tpath}/log #{root}/#{tpath}/casket.tct`

    puts "Starting the TokyoTyrant server (for Hash) on port #{hport}"
    `ttserver -port #{hport} -dmn -pid #{root}/#{hpath}/pid -log #{root}/#{hpath}/log #{root}/#{hpath}/casket.tch`
  end

  task :stop do
    root  = File.join(File.dirname(__FILE__))
    tpath = 'tmp/table'
    hpath = 'tmp/hash'

    [ tpath, hpath ].each do |path|
      file = File.join( root, path, 'pid' )
      if File.exist?( file )
        `kill -TERM \`cat #{file}\``
        FileUtils.rm( file )

      end
    end
  end
end
