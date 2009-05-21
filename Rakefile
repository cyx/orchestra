# -*- coding: utf-8 -*-
desc "Run all the tests for the orchestra library"
task :test do
  cmd = "bacon #{Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].join(' ')}"
  puts `#{cmd}`
end

task :default => :test

namespace :orchestra do
  desc "Download Tokyo Server and Tokyo Tyrant and set them up"
  task :setup do
    TCABINET = "http://tokyocabinet.sourceforge.net/tokyocabinet-1.4.21.tar.gz"
    TTYRANT  = "http://tokyocabinet.sourceforge.net/tyrantpkg/tokyotyrant-1.1.27.tar.gz"

    INSTALL  = "./configure && make && sudo make install"
    EXTRACT  = "cd ~/ && tar zxvf"

    extract    = lambda { |version| "cd ~/ && tar zxvf #{version}.tar.gz && cd #{version}" }
    version_of = lambda { |uri| uri.scan(/([a-zA-Z0-9\-\.\_]+?).tar.gz/).first.first }
    run        = lambda { |version| puts `#{extract.call(version)} && #{INSTALL} && rm -rf #{version}*` }

    `wget #{TCABINET} -O ~/#{version_of.call(TCABINET)}.tar.gz`
    `wget #{TTYRANT} -O ~/#{version_of.call(TTYRANT)}.tar.gz`

    run.call( version_of.call( TCABINET ) )
    run.call( version_of.call( TTYRANT ) )
  end

  desc "Start a cluster of TokyoTyrant servers for each model"
  task :start do
    require 'lib/orchestra'
    require 'fileutils'
    require 'pathname'

    data_path = File.join(Orchestra.root, 'data/models')
    tmp_path  = File.join(Orchestra.root, 'tmp')

    unless File.exist?( data_path )
      puts "Creating data/models"

      FileUtils.mkdir_p( data_path )
    end

    unless File.exist?( tmp_path )
      puts "Creating tmp"
      FileUtils.mkdir_p( tmp_path )
    end

    data_path = Pathname.new(data_path).realpath
    tmp_path  = Pathname.new(tmp_path).realpath
    
    master_start = proc { |c|
      pid    = "#{tmp_path}/#{c.sid}.pid"
      log    = "#{tmp_path}/#{c.sid}.log"
      ulog   = "#{data_path}/#{c.sid}.ulog"
      casket = "#{data_path}/#{c.sid}.tct"

      FileUtils.mkdir_p( ulog )

      puts "Starting a server for #{c.sid} on #{c.host}:#{c.port}"
      `ttserver -port #{c.port} -dmn -pid #{pid} -log #{log} -ulog #{ulog} -sid #{c.sid} #{casket}`
    }

    slave_start = proc { |c, m|
      pid    = "#{tmp_path}/#{c.sid}.pid"
      log    = "#{tmp_path}/#{c.sid}.log"
      rts    = "#{tmp_path}/#{c.sid}.rts"

      ulog   = "#{data_path}/#{c.sid}.ulog"
      casket = "#{data_path}/#{c.sid}.tct"

      FileUtils.mkdir_p( ulog )

      puts "Starting a server for #{c.sid} on #{c.host}:#{c.port}"
      `ttserver -port #{c.port} -dmn -pid #{pid} -log #{log} -ulog #{ulog} -sid #{c.sid} -mhost #{m.host} -mport #{m.port} -rts #{rts} #{casket}`
    }

    Orchestra::Config.clusters.each do |cluster|
      master_start.call( cluster.master )
      cluster.slaves.each do |slave|
        slave_start.call( slave, cluster.master )
      end
    end
  end

  desc "Stop your tokyo tyrant clusters"
  task :stop do
    require 'lib/orchestra'
    require 'fileutils'

    tmp_path = File.join(Orchestra.root, 'tmp')

    stop = proc { |c|
      pid = "#{tmp_path}/#{c.sid}.pid"

      if File.exist?( pid )
        `kill -TERM \`cat #{pid}\``
        puts "Stopping the server for #{c.sid}"
        FileUtils.rm( pid )
      end
    }

    Orchestra::Config.clusters.each do |cluster|
      stop.call(cluster.master)
      cluster.slaves.each { |s| stop.call(s) }
    end
  end

  desc "Delete all data and tmp folders"
  task :cleanup do
    if not ENV['FORCE']
      puts "WARNING: This operation will permanently delete all your data."
      puts "execute this using 'rake orchestra:cleanup FORCE=true'"
    else ENV['FORCE']
      require 'fileutils'
      require 'lib/orchestra'

      data_path = File.join(Orchestra.root, 'data')
      tmp_path  = File.join(Orchestra.root, 'tmp')

      if File.exist?( data_path )
        puts "Deleting data"
        FileUtils.rm_r( data_path )
      end

      if File.exist?( tmp_path )
        puts "Deleting tmp"
        FileUtils.rm_r( tmp_path )
      end
    end
  end

  desc "Stop, cleanup, and start your clusters."
  task :reset => [ :stop, :cleanup, :start ]
end
