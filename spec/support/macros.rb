def set_current_user
  user = Fabricate(:user)
  session[:user_id] = user.id
end

def current_user
  User.find(session[:user_id])
end
