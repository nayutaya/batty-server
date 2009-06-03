
# OpenID認証情報編集フォーム
class OpenIdCredentialEditForm < ActiveForm
  column :openid_url, :type => :text

  validates_presence_of :openid_url
  validates_length_of :openid_url, :maximum => 200, :allow_nil => true
end
