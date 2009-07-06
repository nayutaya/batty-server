
require "uri"
require "net/http"
require "ipaddr"

# HTTPアクション実行
class HttpActionExecutor
  WebHookDispatcher.open_timeout = 5
  WebHookDispatcher.read_timeout = 5
  WebHookDispatcher.user_agent   = "batty (http://batty.nayutaya.jp)"
  WebHookDispatcher.acl_with {
    allow :all
    deny  :addr => "127.0.0.0/8"
    deny  :addr => IPSocket.getaddress(Socket.gethostname).sub(/%.+\z/, "")
  }

  OpenTimeout = 5
  ReadTimeout = 5
  UserAgent   = "batty (http://batty.nayutaya.jp)".freeze

  DenyNetworks = [
    IPAddr.new("127.0.0.0/8"),
    IPAddr.new(IPSocket.getaddress(Socket.gethostname).sub(/%.+\z/, "")),
  ].freeze

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

  def self.build_exectors(event)
    trigger = event.trigger
    return [] unless trigger

    keywords = NoticeFormatter.format_event(event)
    return trigger.http_actions.enable.map { |http_action|
      HttpActionExecutor.from(http_action).replace(keywords)
    }
  end

  def replace(keywords)
    url       = NoticeFormatter.replace_keywords(self.url,       keywords) if self.url
    post_body = NoticeFormatter.replace_keywords(self.post_body, keywords) if self.post_body
    return self.class.new(
      :url         => url,
      :http_method => self.http_method,
      :post_body   => post_body)
  end

  def execute
    dispatcher = WebHookDispatcher.new

    response =
      case @http_method
      when :head then dispatcher.head(URI.parse(self.url))
      when :get  then dispatcher.get(URI.parse(self.url))
      when :post then dispatcher.post(URI.parse(self.url), self.post_body)
      else raise("invalid http method")
      end

    case response.status
    when :success, :failure
      return {:success => response.success?, :message => "#{response.http_code} #{response.message}"}
    else
      return {:success => response.success?, :message => response.message}
    end
  end

  def to_hash
    return {
      :url         => self.url,
      :http_method => self.http_method,
      :post_body   => self.post_body,
    }
  end
end
