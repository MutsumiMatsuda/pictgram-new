class SessionsController < ApplicationController
  def new
  end
def create
  # binding.pry
    @user = User.find_by(email: params[:session][:email])
   if @user && @user.authenticate(params[:session][:password])
     log_in @user
     redirect_to "/users/#{@user.id}", success: "ログインに成功しました"
   else
     flash.now[:danger] = 'ログインに失敗しました'
     render :new
   end
 end

  def destroy
    log_out
    redirect_to root_url, info: 'ログアウトしました'
  end
  private
  def session_params
    params.require(:session).permit(:email, :password)
  end
  private
  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
