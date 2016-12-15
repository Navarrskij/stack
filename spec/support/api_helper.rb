module ApiHelper
  def do_request(url_path, method, options)
    send(method, url_path, { format: :json }.merge(options))
  end
end