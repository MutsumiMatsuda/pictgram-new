class TopicsController < ApplicationController

  def index
    @topics = Topic.all.includes(:favorite_users).order(created_at: :desc)

  end
  def show
    @topic = Topic.find_by(id: params[:id])
  end

  def new
    @topic = Topic.new
  end


  def create
    @topic = current_user.topics.new(topic_params)

    if @topic.save
      redirect_to topics_path, success: '投稿に成功しました'
    else
      flash.now[:danger] = "投稿に失敗しました。"
      render :new
    end
  end

  def edit
    @topic = Topic.find_by(id: params[:id])
    if !@topic || current_user.id != @topic.user_id
      redirect_to user_path(current_user.id), warning: '権限がありません'
  end
end
  def update
    @topic = Topic.find_by(id: params[:id])
        # binding.pry
    if @topic.update(topic_params)
      redirect_to "/topics/#{@topic.id}", success: '投稿を編集しました'
    else
      flash.now[:danger] = "編集に失敗しました。"

      render("topics/edit")
    end
  end

  def destroy
    @topic = Topic.find_by(id: params[:id])
    @topic.destroy
    redirect_to topics_path, warning: '投稿を削除しました'
  end



  private
  def topic_params
    params.require(:topic).permit(:image, :description)
  end
end
