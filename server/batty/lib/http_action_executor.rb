
require "uri"
require "net/http"

# HTTPアクション実行
class HttpActionExecutor
  OpenTimeout = 5
  ReadTimeout = 5
  UserAgent   = "batty (http://batty.nayutaya.jp)".freeze

  def initialize(options = {})
    options = options.dup
    @url         = options.delete(:url)         || nil
    @http_method = options.delete(:http_method) || nil
    @post_body   = options.delete(:post_body)   || nil
    raise(ArgumentError) unless options.empty?
  end

  attr_accessor :url, :http_method, :post_body

  def self.from(http_action)
    return self.new(
      :url         => http_action.url,
      :http_method => (http_action.http_method.blank? ? nil : http_action.http_method.downcase.to_sym),
      :post_body   => http_action.body)
  end

  def execute
    request   = self.create_http_request
    connector = self.create_http_connector

    result =
      begin
        response = connector.start { connector.request(request) }
        {
          :success => response.kind_of?(Net::HTTPSuccess),
          :message => "#{response.code} #{response.message}",
        }
      rescue TimeoutError
        {:success => false, :message => "timeout."}
      rescue Errno::ECONNREFUSED
        {:success => false, :message => "connection refused."}
      rescue Errno::ECONNRESET
        {:success => false, :message => "connection reset by peer."}
      rescue => e
        {:success => false, :message => "#{e.class}: #{e.message}"}
      end

    return result.freeze.each { |k, v| v.freeze }
  end

  protected

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

  def create_http_connector
    uri  = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = OpenTimeout
    http.read_timeout = ReadTimeout

    return http
  end
end
