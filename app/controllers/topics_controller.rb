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
      # html形式でアクセスがあった場合
      format.html {

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

          # 戻り先のURLを設定
          @listUrl = '/topics'
          @listIcon = 'icons/back-to-topics.png'
          if params[:lst].present?
            @listUrl = '/' + params[:lst]
            if @listUrl == '/favorites'
              @listIcon = 'icons/back-to-favorits.png'
            elsif @listUrl == '/users'
              @listUrl += '/' + current_user.id.to_s
              @listIcon = 'icons/back-to-user.png'
            end
          end

          # 表示用のコメントを編集する
          @topic.comments.each do |comment|
            comment.lines = compile_lines(comment)
          end

          @comments = @topic.comments

          lastCommentId = 0
          if @topic.comments.count > 0
            lastCommentId = @topic.comments.last.id;
          end

          render :show
        end
      }

      # json形式でアクセスがあった場合は、params[:message][:id]よりも大きいidがないかMessageから検索して、@new_messageに代入する
      format.json {
        newcomments = Comment.where('id > ? AND topic_id = ?', params[:comment][:id], params[:comment][:topic_id])
        newcomments.each do |comment|
          comment.lines = compile_lines(comment)
        end
        @new_comment = newcomments
      }
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
    if !@topic || current_user.admin? && current_user.id != @topic.user_id
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

  # コメントを編集する
  def compile_lines(comment)
    lines = comment.user.name + '： ' + comment.lines
    # Admin 又は ログインユーザのコメントには削除リンクを追加
    if current_user.admin? || current_user.id == comment.user_id
        lines += '<a href="/comments/delete?'
        lines += 'id=' + comment.id.to_s
        lines += '&' + getLstScrTopParamName + '=' + @lstScrTop.to_s
        lines += '&' + getScrTopParamName + '=' + @scrtop.to_s
        lines += '&' + 'topic_id' + '=' + @topic_id.to_s
        lines += '"><span style="color:#ff0000;">　×</span></a>'
    end
    return lines
  end
end
