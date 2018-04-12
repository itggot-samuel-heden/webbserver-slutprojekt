class App < Sinatra::Base
	enable :sessions
	
	def auto_redirect()
		if session[:user_id] == nil
			redirect('/')
		end
	end

	get '/' do
		"Welcome to Rydez!"
		session[:user_id] = nil
		slim(:index)
	end

	get '/main' do
		if session[:user_id] = nil
			redirect('/')
		end
		id = session[:user_id]
		current_user = find_user(id:session[:user_id])
		slim(:main, locals:{current_user:current_user})
	end

	post '/login' do
		
	end

	get '/register' do
		if session[:user_id] = nil
			redirect('/')
		end
		username = params["username"]
		password = params["password"]
		confirm = params["confirm"]
		slim(:register)
	end

	post '/logout' do
		session[:user_id] = nil
		auto_redirect()
	end
	
end           
