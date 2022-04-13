require "sqlite3"


$db_filename    = "high_score.sql"
$tablename      = "mastermind"   

# Class for establishing a database connection to an SQLite database.
# Creates a mastermind database if one does not already exist.
class ConnectionSQlite

  # Resets the database class instance variable
  def new
    @db = nil
  end

  # Sets the database to the global variable defined above the class and creates it.
  def get_connection
    if @db == nil
      @db = SQLite3::Database.new($db_filename)
      createdb
    end
    @db
  end

  # Creates SQL database table if it does not exist.
  def createdb
    rows = self.get_connection().execute <<-SQL
    CREATE TABLE IF NOT EXISTS #{$tablename}
      (
      id INTEGER PRIMARY KEY,
      score int NOT NULL,
      username varchar(30) NOT NULL
      );
      SQL
  end

  # 
  def execute(query)
    self.get_connection().execute(query)
  end
end

# Class for storing player scores in an SQL database.
# Retrieves scores from database, and sorts them by the highest score.
class User
  attr_accessor :id, :score, :username

  def initialize (array)
    @id            = array[0]
    @score         = array[1]
    @username      = array[2]
  end

  # Inserts the players score inside the database.
  def self.add_user(user_info)
    query = <<-REQUEST
      INSERT INTO #{$tablename} (score, username) VALUES ("#{user_info[:score]}",
              "#{user_info[:username]}")
    REQUEST

    ConnectionSQlite.new.execute(query)
  end

  # Retrieves all rows stored inside the database, sorts by highest score.
  def self.high_score_list
    query = <<-REQUEST
      SELECT * FROM #{$tablename}
      ORDER BY score DESC
    REQUEST
    
    rows = ConnectionSQlite.new.execute(query)
    if rows.any?
      rows.collect do |row|
        User.new(row)
      end
    else
      []
    end
    print_hall_of_fame(rows)
  end

  # Prints the top ten Mastermind scores stored in the database.
  def self.print_hall_of_fame(rows)
    puts "MASTERMIND HALL OF FAME"
    puts "======================="
    rank = 1
    rows.each do |user_data|
      puts "#{rank.to_s.rjust(2, ' ')}.   #{user_data[1].to_s.rjust(3, '0')}   #{user_data[2]}"
      rank += 1
      if rank >= 10
        break
      end
    end
  end

end


def _main()
  # p User.add_user(score: 11, username: "Batman")
  #  User.high_score_list
end

_main()