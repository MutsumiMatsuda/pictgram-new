class FavoritesController < ApplicationController
  def index
    # @favorite_topics = current_user.favorite_topics
    @favorite_topics = Topic.where(id: current_user.favorite_topics).order(created_at: :desc)
  # binding.pry
  end

  def show
    render 'index'
  end

  def add
    favorite = Favorite.new
    do_add favorite

    # 松田変更ここから
    if favorite.save
      redirect_to setScrTop2Url(topics_path, getLstScrTopParamName, getLstScrTopFromParameter), success: 'お気に入りに登録しました'
    else
      redirect_to setScrTop2Url(topics_path, getLstScrTopParamName, getLstScrTopFromParameter), danger: 'お気に入りに登録に失敗しました'
    end
  end

  def remove
    favorite = Favorite.find_by(user_id: current_user.id, topic_id: params[:topic_id])
    favorite.destroy

    redirect_to setScrTop2Url(topics_path, getLstScrTopParamName, getLstScrTopFromParameter), warning: 'お気に入りを削除しました'
  end

  def addfromshow
    favorite = Favorite.new
    do_add favorite

    url = setScrTop2Url(topics_path + '/show', getScrTopParamName, getScrTopFromParameter) + '&topic_id=' + params[:topic_id]
    if favorite.save
      redirect_to url, success: 'お気に入りに登録しました'
    else
      redirect_to url, danger: 'お気に入りに登録に失敗しました'
    end
  end

  def removefromshow
    favorite = Favorite.find_by(user_id: current_user.id, topic_id: params[:topic_id])
    favorite.destroy
    url = setScrTop2Url(topics_path + '/show', getScrTopParamName, getScrTopFromParameter) + '&topic_id=' + params[:topic_id]
    redirect_to url, warning: 'お気に入りを削除しました'
  end

  private
  def do_add(favorite)
    favorite.user_id = current_user.id
    favorite.topic_id = params[:topic_id]
  end

  # 松田変更ここまで

end
