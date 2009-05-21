require 'activerecord'
ActiveRecord::Base.establish_connection({
                                          'adapter' => 'mysql',
                                          'database' => 'orchestra',
                                          'username' => 'root',
                                          'password' => '',
                                          'host' => 'localhost'
                                        })

class ArUser < ActiveRecord::Base
  set_table_name :users

  DROP = "DROP TABLE users"
  CREATE = "CREATE TABLE users ( id int(11) not null auto_increment, email varchar(100) not null, name varchar(100) not null, role varchar(7) not null, access int(1) not null, primary key(id));"

  def self.truncate
    connection.execute(DROP)
    connection.execute(CREATE)
  end
end
