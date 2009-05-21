require File.dirname(__FILE__) + '/test_helper'

describe "the master connection to User" do
  before do
    @master = Orchestra::Connection['User', 'master']
  end
  
  it "should be present" do
    @master.should.not.be.nil
  end
 
  it "should have a host 127.0.0.1" do
    @master.host.should.equal '127.0.0.1'
  end
 
  it "should have a port 54321" do
    @master.port.should.equal 54321 
  end
end

describe "the slave connections to User" do
  before do
    @slave1 =  Orchestra::Connection['User', 'slave']
    @slave2 =  Orchestra::Connection['User', 'slave']
    @slave3 =  Orchestra::Connection['User', 'slave']
    @slave4 =  Orchestra::Connection['User', 'slave']
  end

  describe "the first slave" do
    it "should be present" do
      @slave1.should.not.be.nil
    end

    it "should have a host equal to 127.0.0.1" do
      @slave1.host.should.equal '127.0.0.1'
    end

    it "should have a port equal to 54322" do
      @slave1.port.should.equal 54322 
    end
  end

  describe "the second slave" do
    it "should be present" do
      @slave2.should.not.be.nil
    end

    it "should have a host equal to 127.0.0.1" do
      @slave2.host.should.equal '127.0.0.1'
    end

    it "should have a port equal to 54323" do
      @slave2.port.should.equal 54323
    end
  end

  describe "the third slave" do
    it "should be present" do
      @slave3.should.not.be.nil
    end

    it "should have a host equal to 127.0.0.1" do
      @slave3.host.should.equal '127.0.0.1'
    end
   
    it "should have a port equal to 54324" do
      @slave3.port.should.equal 54324
    end
  end
 
  describe "the fourth slave" do
    it "should be present" do
      @slave4.should.not.be.nil
    end
   
    it "should have a host equal to 127.0.0.1" do
      @slave4.host.should.equal '127.0.0.1'
    end
   
    it "should have a port equal to 54325" do
      @slave4.port.should.equal 54325
    end
  end
end

