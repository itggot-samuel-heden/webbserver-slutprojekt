require_relative './module.rb'

class App < Sinatra::Base
	enable :sessions
	set :session_secret, "Tjena"
	include TodoDB
	
	def auto_redirect()
		if session[:user_id] == nil
			redirect('/')
		end
	end

	get '/' do
		if session[:user_id].nil?
			slim(:index)
		else
			redirect("/user/#{session[:user_id]}")
		end
	end

	post '/login' do
		if session[:user_id] != nil
			redirect('/')
		else
			user = login_info(params[:username])
			session[:user_id] = user["id"]
			redirect("/user/#{session[:user_id]}")
		end
	end

	get '/register' do
		if session[:user_id] != nil
			redirect('/')
		else
			slim(:register)
		end
	end

	post '/register' do
		username = params["username"]
		password = params["password"]
		height = params["height"]
		age = params["age"]

		if username != nil && login_info(username).nil? && params[:password]==params[:confirm]
			create_user(username, BCrypt::Password.create(password), height, age)
			redirect('/')
		else
			puts "Registration failed, please try another username."
			redirect('/register')
		end
	end

	get '/logout' do
		session[:user_id] = nil
		auto_redirect()
	end

	get '/user/:user_id' do
		if session[:user_id] != nil && session[:user_id] == params["user_id"].to_i
			user = login_info_by_id(session[:user_id])
			rides = get_user_rides(session[:user_id])
			slim(:main, locals: {user: user, rides: rides})
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	get '/user/:user_id/edit' do
		if session[:user_id] != nil && session[:user_id] == params["user_id"].to_i
			user = login_info_by_id(session[:user_id])
			slim(:"edit-user", locals: {user: user})
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	post '/user/:user_id/edit' do
		if session[:user_id] != nil && session[:user_id] == params["user_id"].to_i
			edit_user(params["user_id"], params["username"], params["height"], params["age"])
			redirect("/user/#{params['user_id']}")
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	get '/user/:user_id/tickets' do
		if session[:user_id] != nil && session[:user_id] == params["user_id"].to_i
			user = login_info_by_id(session[:user_id])
			rides = []
			list_of_tickets = get_user_tickets(session[:user_id])
			get_all_rides.each {|ride| rides[ride["id"].to_i] = ride}
			slim(:"user-tickets", locals: {user: user, rides: rides, list_of_tickets: list_of_tickets})
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	get '/user/:user_id/tickets/new' do
		if session[:user_id] != nil
			slim(:"new-ticket")
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	post '/user/:user_id/tickets/new' do
		if session[:user_id] != nil
			create_ticket(session[:user_id], params["attraction"], rand(1..5))
			redirect("/user/#{session[:user_id]}/tickets")
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	post '/user/:user_id/tickets/:ticket_id/delete' do
		if session[:user_id] != nil
			delete_ticket(params["ticket_id"])
			redirect("/user/#{session[:user_id]}/tickets")
		else
			"ur not authorized!!1 pls log in or register"
		end
	end

	get '/rides' do
		rides = get_all_rides
		slim(:rides, locals:{rides:rides })
	end

	get '/rides/:ride_id' do
		slim(:ride, :locals => {:ride => get_ride(params["ride_id"])})
	end
end           
