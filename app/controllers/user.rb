get '/users/new' do
	erb :new_user
end

before /users\/\d+/ do
	puts "estamos en el before bueno"
	if session[:user_id] == nil
		puts "No existe una sesion"
		session[:errors] = "no existe una sesion"
		# @error = session[:error]
		redirect to("/")
	end
end

get '/users' do
	id = params[:id]
	@user = User.find("#{id}")
	erb :show_user
end

post '/users' do
	email = params[:email]
	password = params[:password]
	@user = User.create(email: email, password: password)
	redirect to("/users/#{@user.id}")
end

get '/users/:id' do
	id = params[:id]
	@user = User.find("#{id}")
	erb :show_user
end

get '/users/:id/edit' do
	id = params[:id]
	@user = User.find("#{id}")
	erb :edit_user
end

post '/users/:id' do
	name = params[:name]
	email = params[:email]
	password = params[:password]
	id = params[:id]
	user = User.find(id)
	if password == ""
		user.update(email: email)
	else
		user.update(email: email, password: password)	
	end
	redirect to("/users/#{id}")
end

post '/users/:id/delete' do
	id = params[:id]
	user = User.destroy(id)
	session.clear
	redirect to ('/')
end

post '/register' do
	name = params[:name]
	email = params[:email]
	password = params[:password]
	@user = User.create(name: name, email: email, password: password)
	session[:user_id] = @user.id
	redirect to("/users/#{@user.id}")
end

post '/login' do
	email = params[:email]
	password = params[:password]
	user = User.authenticate(email, password)
	if user
		id = user.id
		session[:email] = params[:email]
		session[:user_id] = id
		redirect to("/users/#{id}")		
	else
		session[:errors] = "Datos incorrectos"
		erb :index
	end
end

get '/logout' do
	session.clear
	redirect to('/')
end