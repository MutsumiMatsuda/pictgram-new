class TopicsController < ApplicationController

  def index
    # 松田追加 画面表示位置をgonを介してViewに設定(JavaScript参照用)
    # 一覧の表示位置をpostで持ち回る

    @lstScrTop = getLstScrTopFromParameter
    @lstScrTopTag = hiddenTag getLstScrTopParamName, @lstScrTop
    @topics = Topic.all.includes(:favorite_users).order(created_at: :desc)

  end

  def new
    @topic = Topic.new
  end

  # トピック詳細ページの表示
  def show
    # 松田追加
    respond_to do |format|
    # html形式でアクセスがあった場合は特に何もなし(@messages = Message.allして終わり）
    format.html
    # json形式でアクセスがあった場合は、params[:message][:id]よりも大きいidがないかMessageから検索して、@new_messageに代入する
    format.json { @new_comment = Comment.where('id > ? AND topic_id = ?', params[:comment][:id], params[:comment][:topic_id]) }
    end

    # トピックや画面表示位置のパラメータが無ければ一覧へ飛ばす
    if nilOrEmpty?(params[:topic_id]) || (nilOrEmpty?(params[getScrTopParamNameAsSym]) && nilOrEmpty?(params[getLstScrTopParamNameAsSym]))
      redirect_to topics_path
    else
      # 一覧の表示位置をpostで持ち回る
      setAllInstanceValForTopicShow

      @lstScrTopTag = hiddenTag getLstScrTopParamName, @lstScrTop
      @scrTopTag = hiddenTag getScrTopParamName, @scrtop
      @topicIdTag = hiddenTag 'topic_id', @topic_id

      @topic = Topic.find_by(id: @topic_id)
      @comments = @topic.comments

      lastCommentId = 0
      if @topic.comments.count > 0
        lastCommentId = @topic.comments.last.id;
      end

      render :show
    end

  end

  def create
    @topic = current_user.topics.new(topic_params)

    if @topic.save
      redirect_to topics_path, success: '投稿に成功しました'
    else
      flash.now[:danger] = "画像は3メガバイト以内で、jpg、gif、pngのいずれかにしてください。"
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
