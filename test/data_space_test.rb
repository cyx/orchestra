require File.join(File.dirname(__FILE__), 'test_helper')

describe "a User initialized with email: john@example.com, name: john doe" do
  before do
    @user = User.new( 'email' => 'john@example.com', 'name' => 'john doe' )
  end

  it "should have an attribute email equal to john@example.com" do
    @user.email.should.equal 'john@example.com'
  end

  it "should have an attribute name equal to john doe" do
    @user.name.should.equal 'john doe'
  end

  it "should have a method user[:email] equal to john@example.com" do
    @user[:email].should.equal 'john@example.com'
  end

  it "should have a method user[:name] equal to john doe" do
    @user[:name].should.equal 'john doe'
  end
end

describe "a User initialized with pk: 1, name: john doe" do
  before do
    @user = User.new( 'pk' => 1, 'name' => 'john doe' )
  end

  it "should have an id of 1" do
    @user.id.should.equal 1
  end

  it "should have a name of john doe" do
    @user.name.should.equal 'john doe'
  end

  describe "when assigned the name jane doe" do
    before do
      @user.name = 'jane doe'
    end

    it "should change the name to jane doe" do
      @user.name.should.equal 'jane doe'
    end
  end
end
