require File.join(File.dirname(__FILE__), 'test_helper')

describe "creating a Session" do
  before do
    Session.delete_all
    @session = Session.create('uid' => 1, 'ipaddr' => '222.222.222.222')
    @session.reload
  end
  
  it "should have an id" do
    @session.id.should.not.be.nil
  end

  it "should have a uid of 1" do
    @session.uid.should.equal '1'
  end

  it "should have an ipaddr of 222.222.222.222" do
    @session.ipaddr.should.equal '222.222.222.222'
  end

  it "should be findable by uid" do
    Session.select { |s| s.uid == 1 }.should.not.be.nil
  end
 
  it "should return the exact row" do
    Session.detect { |s| s.uid == 1 }.id.should.equal @session.id
  end

  it "should be able to find by regex" do
    Session.detect { |s| s.ipaddr =~ "^222" }.id.should.equal @session.id
  end
end

