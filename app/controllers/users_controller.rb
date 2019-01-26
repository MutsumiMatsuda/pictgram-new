class UsersController < ApplicationController

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @user = User.find_by(id: params[:id])
    @topics = Topic.where(user_id: params[:id]).order(created_at: :desc)
  end

  def new
    @user = User.new
  end
  
  def create
     @user = User.new(user_params)
     @user.description = "こんにちは！#{@user.name}です！"

   if @user.save
      session[:user_id] = @user.id
     redirect_to topics_path, success: '登録が完了しました'
   else
     flash.now[:danger] = '登録に失敗しました'
     render :new
   end
  end
  def edit
    @user = User.find_by(id: params[:id])
        if !@user || current_user.id != @user.id
    redirect_to edit_user_path(current_user.id), warning: '権限がありません'
    end
  end
  def update
    @user = User.find_by(id: params[:id])
    # binding.pry
    if @user.update(user_params)
      redirect_to "/users/#{@user.id}", success: 'ユーザー情報を編集しました'
    else
     flash.now[:danger] = '編集に失敗しました'
      render("users/edit")
    end
  end
  private
  def user_params
  params.require(:user).permit(:name, :email, :description, :image, :remove_image, :image_cache, :password, :password_confirmation)
  end
end
