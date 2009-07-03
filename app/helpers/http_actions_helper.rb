
module HttpActionsHelper
  def url_host(url)
    # MEMO: キーワードを含むURLはURI.parseでは解析できないため、正規表現でホスト名を取得
    return url[/\Ahttp:\/\/(.+?)\//, 1] || url
  end
end
