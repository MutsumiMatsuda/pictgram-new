class FavoritesController < ApplicationController
  def index
    @lstScrTop = getLstScrTopFromParameter
    @lstScrTopTag = hiddenTag getLstScrTopParamName, @lstScrTop
    @favorite_topics = Topic.where(id: current_user.favorite_topics).order(created_at: :desc)
  end

  def show
    render 'index'
  end

  # topic一覧からのお気に入り登録
  def add
    # 松田変更ここから
    do_add setScrTop2Url(topics_path, getLstScrTopParamName, getLstScrTopFromParameter)
  end

  # topic一覧からのお気に入り削除
  def remove
    do_destroy setScrTop2Url(topics_path, getLstScrTopParamName, getLstScrTopFromParameter)
  end

  # お気に入りtopic一覧からのお気に入り登録
  def addfromfavorites
    # 松田変更ここから
    do_add setScrTop2Url(favorites_path, getLstScrTopParamName, getLstScrTopFromParameter)
  end

  # お気に入りtopic一覧からのお気に入り削除
  def removefromfavorites
    do_destroy setScrTop2Url(favorites_path, getLstScrTopParamName, getLstScrTopFromParameter)
  end

  # ユーザー投稿一覧からのお気に入り登録
  def addfromusers
    # 松田変更ここから
    do_add setScrTop2Url(users_path + '/' + current_user.id.to_s, getLstScrTopParamName, getLstScrTopFromParameter)
  end

  # ユーザー投稿一覧からのお気に入り削除
  def removefromusers
    do_destroy setScrTop2Url(users_path + '/' + current_user.id.to_s, getLstScrTopParamName, getLstScrTopFromParameter)
  end

  # topic詳細からのお気に入り登録
  def addfromshow
    do_add setScrTop2Url(topics_path + '/show', getScrTopParamName, getScrTopFromParameter) + '&' + getLstScrTopParamName + '=' + getLstScrTopFromParameter.to_s + '&topic_id=' + params[:topic_id]
  end

  # topic詳細からのお気に入り削除
  def removefromshow
    do_destroy setScrTop2Url(topics_path + '/show', getScrTopParamName, getScrTopFromParameter) + '&' + getLstScrTopParamName + '=' + getLstScrTopFromParameter.to_s + '&topic_id=' + params[:topic_id]
  end

  protected
  def do_add(url)
    favorite = Favorite.new
    favorite.user_id = current_user.id
    favorite.topic_id = params[:topic_id]
    if favorite.save
      redirect_to url, success: 'お気に入りに登録しました'
    else
      redirect_to url, danger: 'お気に入りに登録に失敗しました'
    end
  end

  def do_destroy(url)
    favorite = Favorite.find_by(user_id: current_user.id, topic_id: params[:topic_id])
    if favorite.destroy
      redirect_to url, success: 'お気に入りを削除しました'
    else
      redirect_to url, danger: 'お気に入りの削除に失敗しました'
    end
  end
  # 松田変更ここまで

end
