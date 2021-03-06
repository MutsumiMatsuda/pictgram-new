# 松田追加
class CommentsController < ApplicationController

  def index
    # コメントした記事のみ表示する
    @commented_topics = current_user.commented_topics
  end

  def create
    comment = Comment.new
    comment.user_id = current_user.id
    comment.topic_id = params[:topic_id].to_i
    comment.lines = params[:lines]

    setAllInstanceValForTopicShow

    url = topics_path + '/show?topic_id=' + @topic_id + '&' + getScrTopParamName + "=" + @scrtop + '&' + getLstScrTopParamName + "=" + @lstScrTop
    if comment.save
      redirect_to url, success: 'コメントを登録しました'
    else
      redirect_to url, danger: 'コメントの登録に失敗しました'
    end
  end

  def delete
    setAllInstanceValForTopicShow
    url = topics_path + '/show?topic_id=' + @topic_id + '&' + getScrTopParamName + "=" + @scrtop + '&' + getLstScrTopParamName + "=" + @lstScrTop

    comment = Comment.find_by(id: params[:id])

    if comment.destroy
      redirect_to url, success: 'コメントを削除しました'
    else
      redirect_to url, danger: 'コメントの削除に失敗しました'
    end
  end

end
