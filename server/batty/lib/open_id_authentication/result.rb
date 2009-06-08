# -*- coding: utf-8 -*-
module OpenIdAuthentication
  class Result
    ERROR_MESSAGES.update({
      :missing      => "OpenID サーバが見つかりませんでした。",
      :invalid      => "OpenID が不正です。",
      :canceled     => "OpenID の検証がキャンセルされました。",
      :failed       => "OpenID の検証が失敗しました。",
      :setup_needed => "OpenID の検証には準備が必要です。",
    })
  end
end
