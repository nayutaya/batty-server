
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
    when :head then execute_by_head(@url)
    when :get  then execute_by_get(@url)
    when :post then execute_by_post(@url, @post_body)
    else raise("invalid http method")
    end
  end

  private

  def execute_by_head(url)
    # TODO: 実装せよ
  end

  def execute_by_get(url)
    # TODO: 実装せよ
  end

  def execute_by_post(url, body)
    # TODO: 実装せよ
  end
end
