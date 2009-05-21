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

    Orchestra::Config.models.each do |c|
      pid    = "#{tmp_path}/#{c['name']}.pid"
      log    = "#{tmp_path}/#{c['name']}.log"
      casket = "#{data_path}/#{c['name']}.tct"

      puts "Starting a server for #{c['name']} on #{c['host']}:#{c['port']}"
      `ttserver -port #{c['port']} -dmn -pid #{pid} -log #{log} #{casket}`
    end
  end

  task :stop do
    require 'lib/orchestra'
    require 'fileutils'

    tmp_path = File.join(Orchestra.root, 'tmp')

    Orchestra::Config.models.each do |c|
      pid = "#{tmp_path}/#{c['name']}.pid"

      if File.exist?( pid )
        `kill -TERM \`cat #{pid}\``
        puts "Stopping the server for #{c['name']}"
        FileUtils.rm( pid )
      end
    end
  end

  task :reset => :stop do
    require 'fileutils'
    require 'lib/orchestra'

    data_path = File.join(Orchestra.root, 'data')

    if File.exist?( data_path )
      FileUtils.rm_r( data_path )
    end

    `rake orchestra:start`
  end
end
