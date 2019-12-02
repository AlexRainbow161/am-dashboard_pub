class SessionsController < ApplicationController
  skip_before_action :authentificate, only: [:new, :create]

  def new
  end

  def create
    username = params[:session][:username].downcase
    password = params[:session][:password]
    user = User.find_by(username: username)
    if user
      if Ldap::LdapHelper.login_as(username, password)
        log_in(user)
        flash[:success] = "Succefully logon"
        redirect_to session[:return_path] ? session[:return_path] : root_path
      else
        flash[:danger] = 'Invalid user name or password'
        render 'new'
      end
    else
      user = Ldap::LdapHelper.login_as(username, password)
      new_user = User.new(user) if user
      if new_user && new_user.save
        log_in(new_user)
        flash[:success] = "Succefully logon"
        redirect_to session[:return_path] ? session[:return_path] : root_path
      else
        flash[:danger] = 'Invalid user name or password'
        render 'new'
      end
    end
  end

  def delete
    log_out
    redirect_to root_path
  end
end
