require 'sqlite3'


$db_filename    = "high_score.sql"
$tablename      = "mastermind"   

 
class ConnectionSQlite
    def new
        @db = nil
    end

    def get_connection
        if @db == nil
            @db = SQLite3::Database.new($db_filename)
            createdb
        end
        @db
    end


    def createdb
        rows = self.get_connection().execute <<-SQL
        CREATE TABLE IF NOT EXISTS #{$tablename}
            (
            id INTEGER PRIMARY KEY,
            score INTEGER NOT NULL,
            username varchar(30) NOT NULL,
            );
            SQL
    end

    def execute(query)
        self.get_connection().execute(query)
    end

end

class User
    attr_accessor :id, :score, :username

    def initialize (array)
        @id            = array[0]
        @score         = array[1]
        @username      = array[2]

    end


    def self.add_user(user_info)
        query = <<-REQUEST
            INSERT INTO #{$tablename} (score, username) 
            VALUES ("#{user_info[:score]}",
                    "#{user_info[:username]}")
        REQUEST

        ConnectionSQlite.new.execute(query)
    end


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
    end

end


def _main()
  p User.add_user(score: 10, username: "Brian")
end

_main()