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
        result = db.execute("SELECT * FROM User WHERE username = ?", username)
        return result.first
    end

    def login_info_by_id(user_id)
        db = connect()
        result = db.execute("SELECT * FROM User WHERE id = ?", user_id)
        return result.first
    end

    def edit_user(user_id, username, height, age)
        db = connect()
        result = db.execute("UPDATE User SET username = ?, height = ?, age = ? WHERE id = ?", username, height, age, user_id)
        return result
    end

    def get_all_rides
        db = connect()
        result = db.execute("SELECT * FROM Attraction")
        return result
    end

    def get_ride(ride_id)
        db = connect()
        result = db.execute("SELECT * FROM Attraction WHERE id = ?", ride_id)
        return result.first
    end

    def get_user_rides(user_id)
        user = login_info_by_id(user_id)
        rides = get_all_rides
        user_rides = []
        
        rides.each do |ride|
            if ride["height_restriction"].to_i <= user["height"].to_i && ride["age_restriction"].to_i <= user["age"].to_i
                user_rides << ride
            end
        end

        return user_rides
    end

    def create_ticket(user_id, ride_id, car_nr)
        db = connect()
        db.execute("INSERT INTO Tickets (attraction_id, car_nr, user_id) VALUES (?,?,?)", ride_id, car_nr, user_id)
    end

    def get_user_tickets(user_id)
        db = connect()
        result = db.execute("SELECT * FROM Tickets WHERE user_id = ?", user_id)
        return result
    end

    def delete_ticket(ticket_id)
        db = connect()
        db.execute("DELETE FROM Tickets WHERE id = ?", ticket_id)
    end
end