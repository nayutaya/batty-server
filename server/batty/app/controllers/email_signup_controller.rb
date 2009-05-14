
# メールサインアップ
class EmailSignupController < ApplicationController
  # TODO: filter_parameter_logging
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:validate])

  # GET /signup/email
  def index
    session[:user_id]     = nil
    session[:signup_form] = nil

    @signup_form = EmailSignupForm.new
  end

  # POST /signup/email/validate
  def validate
    session[:user_id]     = nil
    session[:signup_form] = nil

    @signup_form = EmailSignupForm.new(params[:signup_form])

    if @signup_form.valid?
      session[:signup_form] = @signup_form.attributes
      redirect_to(:action => "validated")
    else
      @signup_form.password              = nil
      @signup_form.password_confirmation = nil
      # TODO: error flash
      render(:action => "index")
    end
  end

  # GET /signup/email/validated
  def validated
    # TODO: 不要なセッションをクリア
    # TODO: セッションからサインアップフォームを取得
    # TODO: サインアップフォームを検証（メールアドレスの重複エラーが発生する可能性がある）
  end

  # POST /signup/email/create
  # TODO: POSTメソッドに制約
  def create
    # TODO: 不要なセッションをクリア
    # TODO: セッションからサインアップフォームを取得
    # TODO: サインアップフォームを検証（メールアドレスの重複エラーが発生する可能性がある）
    # TODO: EmailCredentialレコードを作成
    redirect_to(:action => "created")
  end

  # GET /signup/email/created
  def created
    # TODO: 不要なセッションをクリア
    # TODO: セッションからサインアップフォームを取得
  end

  # GET /signup/email/activation/:activation_token
  def activation
    # TODO: activation_tokenからEmailCredentialを取得
    # nop
  end

  # POST /signup/email/activate
  # TODO: POSTメソッドに制約
  def activate
    # TODO: パラメータからEmailCredentialを取得
    # TODO: activated_atに現在日時を設定
    redirect_to(:action => "activated")
  end

  # GET /signup/email/activated
  def activated
    # nop
  end
end
