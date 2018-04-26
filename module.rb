module TodoDB

    def connect()
        db = SQLite3::Database.new('./database/database.sqlite')
        db.results_as_hash = true
        return db
    end

    def create_user(username, password, height, age)
        db = connect()
        db.execute("INSERT INTO User (username, password, height, age) VALUES (?,?,?,?)", [username, password, height, age])
    end

    def find_username(id:)
        db = connect()
        result = db.execute("SELECT username FROM User WHERE id = ?", id)
        return result[0][0]
    end

    def login_info(username)
        db = connect()
        result = db.execute("SELECT * FROM user WHERE username = ?", username)
        return result
    end

    def verify_permission(id:,attraction_id:)
        db = connect()
        user_data = db.execute("SELECT height,age FROM User WHERE id=?", id)
        attraction_data = db.execute("SELECT height_restriction, age_restriction FROM Attraction WHERE attraction_id=?", attraction_id)
        result = db.execute("SELECT * FROM Ride_permission WHERE user_id=? AND attraction_id=?", [id,attraction_id])
        
        if user_data[0] && user_data[1] >= attraction_data[0] && attraction_data[2]
            db.execute("INSERT INTO Ride_permission(permission_status) VALUES(?)", [0])
        else
            db.execute("INSERT INTO Ride_permission(permission_status) VALUES(?)", [1])
        end

        return result
    end
end