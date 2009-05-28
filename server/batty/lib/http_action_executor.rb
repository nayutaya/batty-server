
require "uri"
require "net/http"

# HTTPアクション実行
class HttpActionExecutor
  UserAgent = "batty (http://batty.nayutaya.jp)".freeze

  def initialize(options = {})
    options = options.dup
    @url         = options.delete(:url)         || nil
    @http_method = options.delete(:http_method) || nil
    @post_body   = options.delete(:post_body)   || nil
    raise(ArgumentError) unless options.empty?
  end

  attr_accessor :url, :http_method, :post_body

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
    request["User-Agent"] = UserAgent

    return request
  end

  def execute
    request = self.create_http_request
    uri     = URI.parse(@url)

    begin
      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = 5
      http.read_timeout = 5
      http.start {
        response = http.request(request)
        return Result.new(
          :success => response.kind_of?(Net::HTTPSuccess),
          :message => "#{response.code} #{response.message}")
      }
    rescue TimeoutError
      return Result.new(:success => false, :message => "timeout.")
    rescue SocketError => e
      return Result.new(:success => false, :message => e.message)
    rescue Errno::ECONNREFUSED
      return Result.new(:success => false, :message => "connection refused.")
    rescue Errno::ECONNRESET
      return Result.new(:success => false, :message => "connection reset by peer.")
    end
  end

  class Result
    def initialize(options = {})
      options = options.dup
      @success = options.delete(:success)
      @message = options.delete(:message)
      raise(ArgumentError) unless options.empty?
    end

    attr_reader :success, :message
  end
end
