module ApplicationHelper

  def truncate_description(description)
    description = simple_format(strip_tags(description).truncate(60))
  end

  # 松田追加

  # 画面表示位置固定用パラメータ名を返す
  # @param [nil]
  # @return [string] 画面表示位置固定用パラメータ名
  def scrTopParamName
    return 'scrtop'
  end

  # 一覧画面表示位置固定用パラメータ名を返す
  # @param [nil]
  # @return [string] 一覧画面表示位置固定用パラメータ名
  def lstScrTopParamName
    return 'lstScrtop'
  end

  # Icon画像に特定のアクションに画面表示位置をパラメータとして渡すリンクのhtmlタグを出力
  # @param [string] コントローラへのpath
  # @param [string] コントローラのaction名
  # @param [integer] コントローラへ渡すid
  # @param [string] アイコンの画像パス
  # @param [string] アイコンのcssクラス名
  # @return [string] 画面表示位置をパラメータとして渡すリンクのhtmlタグ
  def scrTopIcon(url, iconPath, cssCls)
    imgTag = image_tag iconPath, {class: cssCls}
    tagStr =
    "\<a rel=\"nofollow\" href=\"javascript:void(0);\" onclick=\"jumpWithScrTop('" + url + "');\"\>\n" +
    "  " + imgTag + "\n" +
    "\<\/a\>\n"
    return tagStr.html_safe
  end

  # 画面表示位置のパラメータを付与し、画面遷移するJavaScriptを出力
  # @param [nil]
  # @return [string] 画面表示位置のパラメータを付与し、画面遷移するJavaScript
  def getScrTopJs
    script =
      "\<script\>\n" +
      "  // リンク押下時にページ表示位置をパラメータとしてURLに付与して画面遷移\n" +
      "  function jumpWithScrTop(\$url) {\n" +
      "    var scrtop = \$(window).scrollTop();       // 送信時の位置情報を取得\n" +
      "    location.href = \$url+'='+scrtop;\n" +
      "  }\n" +
      "\</script\>\n"
    return script.html_safe
  end

  def putDoScrTopJs(paramName)
    script =
      "\<script\>\n" +
      "  window.onload = function(){\n" +
      "    $(window).scrollTop($('." + paramName + "').val());\n" +
      "  }\n" +
      "\</script\>\n"
    return script.html_safe
  end

end
