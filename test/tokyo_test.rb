require File.join(File.dirname(__FILE__), 'test_helper')

describe "Orchestra::Tokyo" do
  describe "User.post( email: john@doe.com )" do
    before do
      @before_post_size = User.size

      @user = User.post( 'email' => 'john@doe.com' )
    end

    it "should return a User instance" do
      @user.should.be.instance_of( User )
    end

    it "should increment User.size by 1 " do
      User.size.should.equal @before_post_size + 1
    end

    it "should return a user with an id" do
      @user.id.should.not.be.nil
    end

    it "should return a user with _rev" do
      @user['_rev'].should.not.be.nil
    end

    it "should return a user with _rev containing at least 13 ints" do
      @user['_rev'].should.match(/^[0-9]{13,}$/)
    end

    it "should return a user with _class being User" do
      @user['_class'].should.equal 'User'
    end

    it "should return a user with created_at containing at least 10 ints" do
      @user['created_at'].should.match(/^[0-9]{10,}$/)
    end

    it "should return a user with updated_at containing at least 10 ints" do
      @user['updated_at'].should.match(/^[0-9]{10,}$/)
    end

    describe "User.get( <id> )" do
      before do
        @found = User.get( @user.id )
      end

      it "should return a user instance" do
        @found.should.be.instance_of(User)
      end

      it "should have an email of john@doe.com" do
        @found.email.should.equal 'john@doe.com'
      end
    end

    describe "User.get( some non existent id )" do
      before do
        @nonexistent = User.get( 'bla bla bla' )
      end

      it "should be nil" do
        @nonexistent.should.be.nil
      end
    end

    describe "User.put( <id>, email: jane@doe.com )" do
      before do
        @prev_user_size = User.size
        @updated = User.put( @user.id, 'email' => 'jane@doe.com' )
      end

      it "should not increase User.size" do
        @prev_user_size.should.equal User.size
      end

      it "should change email to jane@doe.com" do
        @updated = User.get( @user.id )
        @updated.email.should.equal 'jane@doe.com'
      end
    end

    describe "User.delete( <id> )" do
      before do
        @prev_user_size = User.size
        @deleted = User.delete( @user.id )
      end

      it "should decrease User.size" do
        @prev_user_size.should.equal(User.size + 1)
      end

      describe "User.get( <id> )" do
        before do
          @not_found = User.get( @user.id )
        end

        it "should return nil" do
          @not_found.should.be.nil
        end
      end
    end
  end

  describe "InstanceMethods" do
    describe "a user with an email john@doe.com" do
      before do
        @user = User.post( 'email' => 'john@doe.com' )
      end

      describe "when assigned the email jane@doe.com and saved" do
        before do
          @user.email = 'jane@doe.com'
          @result = @user.save
        end

        it "should return true" do
          @result.should.equal true
        end

        describe "when refreshed" do
          before do
            @user.refresh
          end

          it "should have an email of jane@doe.com" do
            @user.email.should.equal 'jane@doe.com'
          end
        end

        describe "when deleted" do
          before do
            @deleted = @user.delete
          end

          it "should return true" do
            @deleted.should.equal true
          end

          it "should truly delete the record" do
            User.get(@user.id).should.be.nil
          end
        end
      end
    end
  end

end

