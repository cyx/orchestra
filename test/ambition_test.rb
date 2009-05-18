require File.join(File.dirname(__FILE__), 'test_helper')

describe "given jane and john are writers and bob is an admin" do
  before do
    User.delete_all
    @jane = User.post( 'email' => 'jane@doe.com', 'role' => 'writer', 'level' => '1' )
    @john = User.post( 'email' => 'john@doe.com', 'role' => 'writer', 'level' => '2' )

    @bob  = User.post( 'email' => 'bob@admin.com', 'role' => 'admin', 'level' => '3' )
  end

  describe "select all writers" do
    before do
      @selection = User.select { |u| u.role == 'writer' }
    end

    it "should return 2 results" do
      @selection.size.should.equal 2
    end

    it "should return jane and john" do
      @selection.entries.should.equal [ @jane, @john ]
    end
  end

  describe "select users with level >= 2" do
    before do
      @selection = User.select { |u| u.level >= 2 }
    end

    it "should contain 2 results" do
      @selection.size.should.equal 2
    end

    it "should return john and bob" do
      @selection.entries.should.equal [ @john, @bob ]
    end
  end

  describe "select users with level > 0" do
    before do
      @selection = User.select { |u| u.level > 0 }
    end

    it "should return 3 results" do
      @selection.size.should.equal 3
    end

    it "should return jane john and bob" do
      @selection.entries.should.equal [@jane, @john, @bob]
    end

  end


end

