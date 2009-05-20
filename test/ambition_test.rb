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
    @mark = User.create( 'name' => 'abaya, mark', 'type' => 'rocker' )
    @pepe = User.create( 'name' => 'smith, pepe', 'type' => 'rocker' )
    @rico = User.create( 'name' => 'blanco, rico', 'type' => 'rocker' )
    @david = User.create( 'name' => 'aguire, david', 'type' => 'rocker' )
  end

  describe "when sorted by name" do
    before do
      @sorted = User.sort_by { |u| u.name }
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

  describe "when sorted by name and sliced 0, 2" do
    before do
      @sliced = User.sort_by { |u| u.name }.slice( 0, 2 )
    end

    it "should return 2 entries only" do
      @sliced.size.should.equal 2
    end

    it "should return only mark abaya and david" do
      @sliced.entries.should == [ @mark, @david ]
    end
  end

  describe "when sorted by name and asked who's first" do
    before do
      @first = User.sort_by { |u| u.name }.first
    end

    it "should return mark" do
      @first.should.equal @mark
    end
  end

  describe "when sorted by name and detected name with pepe" do
    before do
      @result = User.sort_by { |u| u.name }.detect { |u| u.name =~ 'pepe' }
    end

    it "should return pepe" do
      @result.should == @pepe
    end
  end

  describe "when asked if there's any users with name equal to mark" do
    before do
      @result = User.any? { |u| u.name == 'abaya, mark' }
    end

    it "should return true" do
      @result.should.equal true
    end
  end

  describe "when asked if all users are rockers" do
    before do
      @result = User.all? { |u| u.type == 'rocker' }
    end

    it "should return true" do
      @result.should.equal true
    end
  end

  describe "when asked if there's any user available" do
    before do
      @result = User.any?
    end

    it "should return true" do
      @result.should.equal true
    end
  end

  describe "when asked who's first" do
    it "should return User" do
      User.first.should.be.instance_of(User)
    end
  end

  describe "when we check if users are empty" do
    it "should return false" do
      User.empty?.should.equal false
    end

    describe "when we delete_all users" do
      User.delete_all
      User.empty?.should.equal true
    end
  end

  describe "when we execute each on users sorted by name" do
    before do
      @results = []
      User.sort_by { |u| u.name }.each { |u| @results << u }
    end

    it "should return mark first" do
      @results.first.should.equal @mark
    end

    it "should return david second" do
      @results.second.should.equal @david
    end

    it "should return rico third" do
      @results.third.should.equal @rico
    end

    it "should return pepe last" do
      @results.fourth.should.equal @pepe
    end
  end

end
