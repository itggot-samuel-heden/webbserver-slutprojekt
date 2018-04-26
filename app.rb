require_relative './module.rb'

class App < Sinatra::Base
	enable :sessions
	db = SQLite3::Database.open("./database/database.sqlite")

	include TodoDB
	
	def auto_redirect()
		if session[:user_id] == nil
			redirect('/')
		end
	end

	get '/' do
		"Welcome to Rydez!"
		session[:user_id] == nil
		slim(:index)
	end

	get '/main' do
		if session[:user_id] == nil
			redirect('/')
		end
		id = session[:user_id]
		current_user = find_user(id:session[:user_id])
		slim(:main, locals:{current_user:current_user})
	end

	#post '/login' do
	#	if session[:user_id] = nil
	#		redirect('/')
	#	end
	#	username = params["username"]
	#	password = params["password"]
	#end

	get '/register' do
		if session[:user_id] != nil
			redirect('/')
		end
		slim(:register)
	end

	post '/register' do
		username = params["username"]
		password = params["password"]
		height = params["height"]
		age = params["age"]

		if username != nil
			if login_info(username).empty? == true
				if params[:password]==params[:confirm]

					encrypted_password = BCrypt::Password.create(password)
					create_user(username, encrypted_password, height, age)
				end
			end
		else
			error_message = "Registration failed, please try another username."
			redirect('/register')
		end
		redirect('/register')
	end

	post '/logout' do
		session[:user_id] == nil
		auto_redirect()
	end


end           
