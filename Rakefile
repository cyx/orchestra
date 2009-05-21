# -*- coding: utf-8 -*-
desc "Run all the tests for the orchestra library"
task :test do
  cmd = "bacon #{Dir[File.dirname(__FILE__) + '/test/**/*_test.rb'].join(' ')}"
  puts `#{cmd}`
end

task :default => :test

namespace :orchestra do
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
