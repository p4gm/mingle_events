module MingleEvents
  module Http
    extend self

    MAX_RETRY_TIMES = 5

    # get response body for a url, a block can be passed in for request pre-processing
    def get(url, retry_count=0, &block)
      rsp = fetch_page_response(url, &block)
      case rsp
      when Net::HTTPSuccess
        rsp.body
      when Net::HTTPUnauthorized
        raise HttpError.new(rsp, url, %{
If you think you are passing correct credentials, please check
that you have enabled Mingle for basic authentication.
See <http://www.thoughtworks-studios.com/mingle/3.3/help/configuring_mingle_authentication.html>.})
      when Net::HTTPBadGateway, Net::HTTPServiceUnavailable, Net::HTTPGatewayTimeOut
        raise HttpError.new(rsp, url) if retry_count >= MAX_RETRY_TIMES
        cooldown = retry_count * 2
        MingleEvents.log.info "Getting service error when get page at #{url}, retry after #{cooldown}s..."
        sleep cooldown
        get(url, retry_count + 1, &block)
      else
        raise HttpError.new(rsp, url)
      end
    end

    private
    def fetch_page_response(url, &block)
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      path = uri.request_uri

      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      MingleEvents.log.info "Fetching page at #{path}..."

      start = Time.now
      req = Net::HTTP::Get.new(path)
      yield(req) if block_given?
      rsp = http.request(req)
      MingleEvents.log.info "...#{path} fetched in #{Time.now - start} seconds."
      rsp
    end
  end
end
