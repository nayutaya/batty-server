
# HTTPアクション実行
class HttpActionExecutor
  def initialize(options = {})
    options = options.dup
    @url         = options.delete(:url)         || nil
    @http_method = options.delete(:http_method) || nil
    @post_body   = options.delete(:post_body)   || nil
    raise(ArgumentError) unless options.empty?
  end

  attr_accessor :url, :http_method, :post_body

  def execute
    case @http_method
    when :head then execute_by_head
    when :get  then execute_by_get
    when :post then execute_by_post
    else raise("invalid http method")
    end
  end

  private

  def execute_by_head
    # nop
  end

  def execute_by_get
    # nop
  end

  def execute_by_post
    # nop
  end
end
