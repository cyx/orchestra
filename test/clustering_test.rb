require File.join(File.dirname(__FILE__), 'test_helper')
require 'digest/md5'

describe "Group connections" do
  before do
    @masters = [ 
      Orchestra::Connection['Group', 'master', 0],
      Orchestra::Connection['Group', 'master', 1]
    ]
  
    @slaves = [
      Orchestra::Connection['Group', 'slave', 0],
      Orchestra::Connection['Group', 'slave', 1],
      Orchestra::Connection['Group', 'slave', 2],
      Orchestra::Connection['Group', 'slave', 3]
    ]

    @masters.each { |m| m.clear }
    @slaves.each  { |s| s.clear }
  end
  
  describe "writing hello:konnichiwa to Group master 0" do
    before do
      @masters[0]['hello'] = { 'romaji' => 'konnichiwa' }
    end
  
    it "should make hello available to master1" do
      @masters[1]['hello'].should.not.be.nil
    end

    it "should make hello available to all the slaves too" do
      @slaves.each do |s|
        s['hello'].should.not.be.nil
      end
    end
  end

  describe "given the words in fixtures/words.txt" do
    before do
      @words = File.read( File.dirname(__FILE__) + '/fixtures/words.txt').split("\n")
    end
 
    describe "writing alternately to masters 0 and 1" do
      before do
        @words.each_with_index do |word, idx|
          @masters[ idx % 2 ][Digest::MD5.hexdigest(word)] = { 'word' => word }
        end
      end
    
      it "should make all words available to master 0" do
        @words.each do |word|
          @masters[0][Digest::MD5.hexdigest(word)].should.not.be.nil
        end
      end

      it "should make all words available to master 1" do
        @words.each do |word|
          @masters[1][Digest::MD5.hexdigest(word)].should.not.be.nil
        end
      end

      it "should make all words available to slaves 0-3" do
        @words.each do |word|
          @slaves[ rand(4) ][Digest::MD5.hexdigest(word)].should.not.be.nil
        end
      end
    end
  end
end
