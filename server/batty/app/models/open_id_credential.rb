
# OpenIDログイン情報
class OpenIdCredential < ActiveRecord::Base
  belongs_to :user

  # TODO: identity_urlの存在を検証
  # TODO: identity_urlの文字数を検証
  # TODO: identity_urlのフォーマットを検証
end
