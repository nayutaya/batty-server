
# メールサインアップ
class EmailSignupController < ApplicationController
  # TODO: filter_parameter_logging
  verify(
    :method => :post,
    :render => {:text => "Method Not Allowed", :status => 405},
    :only   => [:validate, :create, :activate])

  before_filter :clear_session_user_id, :only => [:created, :activation, :activate, :activated]
  before_filter :clear_session_signup_form, :only => [:activation, :activate, :activated]

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
    session[:user_id] = nil

    # TODO: サインアップフォームを検証（メールアドレスの重複エラーが発生する可能性がある）

    @signup_form = EmailSignupForm.new(session[:signup_form])
    if @signup_form.valid?
      render
    else
      # TODO: flash
      render(:action => "index")
    end
  end

  # POST /signup/email/create
  def create
    session[:user_id] = nil

    @signup_form = EmailSignupForm.new(session[:signup_form])
    if @signup_form.valid?
      User.transaction {
        @user = User.new
        @user.user_token = User.create_unique_user_token
        @user.nickname   = nil
        @user.save!

        @credential = EmailCredential.new(@signup_form.to_email_credential_hash)
        @credential.activation_token = EmailCredential.create_unique_activation_token
        @credential.user_id          = @user.id
        @credential.save!
      }

      # TODO: アクティベーションメールの送信

      redirect_to(:action => "created")
    else
      render(:action => "index")
    end
  end

  # GET /signup/email/created
  def created
    @signup_form = EmailSignupForm.new(session[:signup_form])
    @credential  = EmailCredential.find_by_email(@signup_form.email)
  end

  # GET /signup/email/activation/:activation_token
  def activation
    @credential = EmailCredential.find_by_activation_token(params[:activation_token])
    @activated  = @credential.try(:activated?)
  end

  # POST /signup/email/activate
  def activate
    @credential = EmailCredential.find_by_activation_token(params[:activation_token])

    unless @credential
      set_error("無効なアクティベーションキーです。")
      redirect_to(root_path)
      return
    end

    if @credential.activated?
      set_error("既に本登録されています。")
      redirect_to(root_path)
      return
    end

    @credential.activated_at = Time.now
    @credential.save

    redirect_to(:action => "activated")
  end

  # GET /signup/email/activated
  def activated
    # nop
  end

  private

  def clear_session_user_id
    session[:user_id] = nil
    return true
  end

  def clear_session_signup_form
    session[:signup_form] = nil
    return true
  end
end
