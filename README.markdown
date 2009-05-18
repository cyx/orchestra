Orchestra
=========

Orchestra will contain the following packages:

- Tokyo (a wrapper for Rufus::Tokyo adding fundamential ORM functionality)
- REST  (an easy way to consume and publish your models)

Tokyo Wrapper: Basic CRUD methods
---------------------------------

The tokyo wrapper will be a very basic ORM implementation similar to
ActiveRecord's CRUD methods, but will adopt some of Ambitions API when
it comes to searching.

Examples:

    user = User.create( 'email' => 'john@example.com' )
    => #<User:0x98b70 @attributes={"email"=>"john@example.com", "_rev"=>"1242273425590", "_class"=>"User", "updated_at"=>"1242273425", "created_at"=>"1242273425"}, @id=1>
    
    user.id
    => 1

    user.email = 'jane@example.com'
    => "jane@example.com"

    user.save
    => true

    user.reload
    => true

    user.email
    => jane@example.com

You may notice that there's some metadata embedded in the attributes
above. This isn't final and may change in the future.

Tokyo Wrapper: Ambition-like interface
--------------------------------------

You may ask, "why do it yourself?". Well, ambition doesn't work with
Ruby 1.9 and I wanna push forward with ruby (specifically, ParseTree
doesn't work with Ruby 1.9, which is used by Ambition).

Examples:

    # == SELECTING ==

    User.select { |u| u.name == 'john doe' }
   
    User.select { |u| u.email.ends_with?('@yahoo.com') }

    # Or you can do

    User.select { |u| u.email =~ "@yahoo.com$" }   
    # but I guess this is slower since it uses regular expressions.

    # Selecting by numbers is also possible

    User.select { |u| u.access_level <= 3 }
    User.select { |u| u.access_level > 4  }

    # Negation is possible through the use of the _not_ method
    User.select { |u| u.email.not == 'john@example.com' }

    # == SORTING ==

    User.select { |u| u.role == 'admin' }.sort_by { |u| u.name }

    # Or you can sort by descending order

    User.select { |u| u.role == 'admin' }.sort_by { |u| u.name(:desc) }

REST
----

Consuming and Publishing APIs

_no documentation yet_
