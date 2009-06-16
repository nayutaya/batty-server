
# ヘルプ
class HelpController < ApplicationController
  before_filter :authentication
  before_filter { |c| c.instance_eval { @topic_path = [] }; true }
  before_filter :add_root_to_topic_path
  before_filter :add_index_to_topic_path, :except => [:index]

  # GET /help
  def index
    # nop
  end

  private

  def add_root_to_topic_path
    @topic_path << ["トップ", root_path]
  end

  def add_index_to_topic_path
    @topic_path << ["ヘルプ", url_for(:controller => "help")]
  end
end
