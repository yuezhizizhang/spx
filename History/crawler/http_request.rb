require 'net/http'
require 'net/https'
require 'active_support/core_ext/object/blank'

module Quant
  class HttpRequest

    def self.http_download(params)
      url = params.fetch(:url, nil)
      query = params.fetch(:query, nil)

      return nil if url.blank?
      uri = parse_uri(url)

      return nil unless uri
      uri.query = URI.encode_www_form(query) unless query.blank?

      http = Net::HTTP.new(uri.host, uri.port)
      if uri.port == 443
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = true
      end

      uri_path = (uri.path.length > 0 ? uri.path : '/')
      full_path = uri_path.dup
      full_path += "?#{uri.query}" unless uri.query.blank?

      request = Net::HTTP::Get.new(full_path)
      http.request(request)
    end

    def self.parse_uri(url)
      return nil if url.blank?
      URI.parse(url)
    end

  end
end