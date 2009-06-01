
# メールアドレス
class EmailsController < ApplicationController
  EditFormClass = EmailAddressEditForm

  before_filter :authentication
  before_filter :authentication_required

  # GET /emails/new
  def new
    @edit_form = EditFormClass.new
  end

  # POST /emails/create
  # TODO: 実装せよ
end
