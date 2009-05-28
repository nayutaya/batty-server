
require "uri"
require "net/http"

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

  # FIXME: User-Agentを追加する
  def create_http_request
    klass = 
      case @http_method
      when :head then Net::HTTP::Head
      when :get  then Net::HTTP::Get
      when :post then Net::HTTP::Post
      else raise("invalid http method")
      end

    request = klass.new(URI.parse(@url).request_uri)
    request.body = @post_body if @http_method == :post

    return request
  end

=begin
e = HttpActionExecutor.new
e.url = "http://batty.nayutaya.jp/head?query"
e.http_method = :head
e.post_body   = "body"
e.execute

e.url = "http://batty.nayutaya.jp/get?query"
e.http_method = :get
e.post_body   = "body"
e.execute

e.url = "http://batty.nayutaya.jp/post?query"
e.http_method = :post
e.post_body   = "body"
e.execute
=end

  def execute
    request = self.create_http_request
    uri     = URI.parse(@url)

    response = nil
    Net::HTTP.start(uri.host, uri.port) { |http|
      response = http.request(request)
    }

    return response
  end

=begin
  def execute
    case @http_method
    when :head then execute_by_head(@url)
    when :get  then execute_by_get(@url)
    when :post then execute_by_post(@url, @post_body)
    else raise("invalid http method")
    end
  end
=end

  private

=begin
  def execute_by_head(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.start
    begin
      response = http.head(uri.path, "User-Agent" => "ruby")
      response_code = response.code
      response_body = response.body
    ensure
      http.finish
    end
  end

  def execute_by_get(url)
    # TODO: 実装せよ
  end

  def execute_by_post(url, body)
    # TODO: 実装せよ
  end
=end
end
