module Maglev
  class API
    class << self
      include Maglev::API::Options
      include Maglev::API::HTTP

      def http_call(method, url, call_options = {}, &block)
        _options = call_options
        _options.merge! self.default_url_options || {}

        if query = _options.delete(:query)
          url += "?" if url.index("?").nil?

          url += query.map { |k,v| "#{k}=#{v}"}.join('&')
        end

        BubbleWrap::HTTP.send(method, complete_url(url), _options) do |response|
          if response.ok?
            json = BubbleWrap::JSON.parse(response.body.to_str)
            block.call response, json
          else
            block.call response, nil
          end
        end
      end
    end

    default_url_options({headers: {:Accept => "application/json"}})
    root("json")
  end
end