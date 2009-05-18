require File.join(File.dirname(__FILE__), 'test_helper')

describe "given jane and john are writers and bob is an admin" do
  before do
    User.delete_all
    @jane = User.post( 'email' => 'jane@doe.com', 'role' => 'writer', 'level' => '1' )
    @john = User.post( 'email' => 'john@doe.com', 'role' => 'writer', 'level' => '2' )

    @bob  = User.post( 'email' => 'bob@admin.com', 'role' => 'admin', 'level' => '3' )
    @dave = User.post( 'email' => 'dave@admin.com', 'role' => 'admin/manager')
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

  describe "select users with level < 3" do
    before do
      @selection = User.select { |u| u.level < 3 }
    end

    it "should return 2 users" do
      @selection.size.should.equal 2
    end

    it "should return jane and john" do
      @selection.entries.should == [ @jane, @john ]
    end
  end

  describe "select users with level <= 3" do
    before do
      @selection = User.select { |u| u.level <= 3 }
    end

    it "should return 3 entries" do
      @selection.size.should.equal 3
    end

    it "should return jane, john and bob" do
      @selection.entries.should == [ @jane, @john, @bob ]
    end
  end

  describe "select users with email containing @doe.com" do
    before do
      @selection = User.select { |u| u.email.include?( '@doe.com' ) }
    end

    it "should return 2 entries" do
      @selection.size.should.equal 2
    end

    it "should return jane and john" do
      @selection.entries.should == [ @jane, @john ]
    end
  end

  describe "select users with role beginning with admin" do
    before do
      @selection = User.select { |u| u.role.starts_with?('admin') }
    end

    it "should return 2 entries" do
      @selection.size.should.equal 2
    end

    it "should return bob and dave" do
      @selection.entries.should.equal [ @bob, @dave ]
    end
  end

  describe "select users with email ending in @doe.com" do
    before do
      @selection = User.select { |u| u.email.ends_with?( '@doe.com' ) }
    end

    it "should return 2 entries" do
      @selection.size.should.equal 2
    end

    it "should return jane and john" do
      @selection.entries.should.equal [ @jane, @john ]
    end
  end

  describe "select users with email NOT ending in @doe.com" do
    before do
      @selection = User.select { |u| u.email.not.ends_with?( '@doe.com' ) }
    end

    it "should return 2 entries" do
      @selection.size.should.equal 2
    end

    it "should return bob and dave" do
      @selection.entries.should.equal [ @bob, @dave ]
    end
  end

  describe "users with writer roles" do
    before do
      @selection = User.select { |u| u.role == 'writer' }
    end

    describe "when sorted by level" do
      before do
        @sorted = @selection.sort_by { |u| u.level }
      end

      it "should return jane and john in order" do
        @sorted.entries.first.should.equal @jane
        @sorted.entries.last.should.equal @john
      end
    end

    describe "when sorted by level (DESC)" do
      before do
        @sorted = @selection.sort_by { |u| u.level(:desc) }
      end

      it "should return john and jane in order" do
        @sorted.entries.first.should.equal @john
        @sorted.entries.last.should.equal @jane
      end
    end
  end

  describe "users with writing roles AND level = 2" do
    before do
      @selection = User.select { |u| u.role == 'writer' and u.level == 2 }
    end

    it "should return one result" do
      @selection.size.should.equal 1
    end

    it "should return john" do
      @selection.entries.first.should.equal @john
    end
  end
end

describe "given mark abaya, rico blanco, pepe smith, and david aguire" do
  before do
    User.delete_all
    @mark = User.create( 'name' => 'abaya, mark' )
    @pepe = User.create( 'name' => 'smith, pepe' )
    @rico = User.create( 'name' => 'blanco, rico' )
    @david = User.create( 'name' => 'aguire, david' )
  end

  describe "when sorted by name" do
    before do
      @sorted = User.select { |u| u._class == 'User' }.sort_by { |u| u.name }
    end

    it "should return mark abaya as the first result" do
      @sorted.entries.first.should ==  @mark
    end

    it "should return david as the second result" do
      @sorted.entries.second.should == @david
    end

    it "should return rico as the third" do
      @sorted.entries.third.should == @rico
    end

    it "should return pepe as the last" do
      @sorted.entries.fourth.should == @pepe
    end


  end


end
