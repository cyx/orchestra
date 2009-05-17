Orchestra
=========

Orchestra will contain the following packages:

- Tokyo (a wrapper for Rufus::Tokyo adding fundamential ORM functionality)
- REST  (an easy way to consume and publish your models)

Tokyo Wrapper
-------------

The tokyo wrapper will be a very basic ORM implementation similar to
ActiveRecord's CRUD methods, but will adopt some of Ambitions API when
it comes to searching.

Examples:
`
user = User.create( 'email' => 'john@example.com' )
=> #<User:0x0000000098b070 @attributes={"email"=>"john@example.com",
"_rev"=>"1242273425590", "_class"=>"User", "updated_at"=>"1242273425",
"created_at"=>"1242273425"}, @id=1>
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
`

You may notice that there's some metadata embedded in the attributes
above. This isn't final and may change in the future.

REST
----

Consuming and Publishing APIs

_no documentation yet_
