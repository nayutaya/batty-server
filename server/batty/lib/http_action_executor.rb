
# HTTPアクション実行
class HttpActionExecutor
  def initialize(options = {})
    options = options.dup
    @url         = options.delete(:url)
    @http_method = options.delete(:http_method)
    @post_body   = options.delete(:post_body)
    raise(ArgumentError) unless options.empty?
  end
end
