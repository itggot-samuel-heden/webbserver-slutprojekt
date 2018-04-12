def create_user(username:, password:)
    db = connect()
    db.execute("INSERT INTO (username, password) VALUES(?,?)", [username,password])
end

def find_username(id:)
    db = connect()
    result = db.execute("SELECT username FROM user WHERE id = ?", id)
    return result[0][0]
end

def login_info(username:)
    db = connect()
    result = db.execute("SELECT * FROM user WHERE username = ?", username)
    module Database
end

def check_permission(id:,goal_id:)
    db = connect()
    db.execute("SELECT * FROM Ride_permission WHERE user_id=? AND attraction_id=?", [id,attraction_id])
end