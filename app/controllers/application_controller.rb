class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :info, :warning, :danger

  before_action :current_user,:logged_in?
  helper_method :current_user,:logged_in?
  # 松田追加
  helper_method :nilOrEmpty?, :getScrTopFromParameter, :setScrTop2Url

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  # 松田追加
  # nilか空文字かの真偽値を返す
  # @param [object] 対象のobject
  # @return [string] 画面表示位置をパラメータとして渡すリンクのhtmlタグ
  def nilOrEmpty?(obj)
    return obj.nil? || obj.empty?
  end

  # 画面表示位置固定用パラメータ名を返す
  # @param [nil]
  # @return [string] 画面表示位置固定用パラメータ名
  def getScrTopParamName
    return view_context.scrTopParamName
  end
  def getScrTopParamNameAsSym
    view_context.scrTopParamName.to_sym
  end

  # 一覧画面表示位置固定用パラメータ名を返す
  # @param [nil]
  # @return [string] 一覧画面表示位置固定用パラメータ名
  def getLstScrTopParamName
    return view_context.lstScrTopParamName
  end
  def getLstScrTopParamNameAsSym
    view_context.lstScrTopParamName.to_sym
  end

  # パラメータから画面表示位置を取得する
  # パラメータに該当値がない場合は、0を返す
  # @param [nil]
  # @return [integer] 画面表示位置
  def getScrTopFromParameter
    scrtop = 0
    if !nilOrEmpty?(params[getScrTopParamNameAsSym])
      scrtop = params[getScrTopParamNameAsSym]
    end
    return scrtop
  end

  # パラメータから一覧画面表示位置を取得する
  # パラメータに該当値がない場合は、0を返す
  # @param [nil]
  # @return [integer] 画面表示位置
  def getLstScrTopFromParameter
    lstScrtop = 0
    if !nilOrEmpty?(params[getLstScrTopParamNameAsSym])
      lstScrtop = params[getLstScrTopParamNameAsSym]
    end
    return lstScrtop
  end

  # パラメータから画面表示位置を取得し、urlにパラメータとして加える
  # @param [nil]
  # @return [string] 画面表示位置を追記したurl
  def setScrTop2Url(url, paramName, value)
    path =  url + '/?' + paramName + '=' + value.to_s
    return path
  end

  # パラメータから画面表示位置を取得し、gonのscrtopに設定する
  # パラメータに該当値がない場合は、0が設定される
  # @param [nil]
  # @return [nil]
  def hiddenTag(className, value)
    html = '<input type="hidden" class="' + className + '" name ="' + className + '" value="' + value.to_s + '"/>'
    return html
  end

  # トピック詳細ページ用のインスタンス変数を設定する
  def setAllInstanceValForTopicShow
    # 一覧の表示位置をpostで持ち回る
    @lstScrTop = getLstScrTopFromParameter
    @scrtop = getScrTopFromParameter
    @topic_id = params[:topic_id]
  end
end
