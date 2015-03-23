enable :sessions
set :session_secret, '3094f093ir0394ir0394ir093ir0934ir0394i'
set :socks, {}

helpers do
  def current_user
    session[:current_user]
  end

  def logged_in?
    !current_user.nil?
  end

  def protect!(fallback)
    redirect fallback unless logged_in?
  end
end
