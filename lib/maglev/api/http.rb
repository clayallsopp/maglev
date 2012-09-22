module Maglev
  module API
    module HTTP
      # EX
      # Question.get(a_question.custom_url) do |response, json|
      #   p json
      # end
      def get(url, params = {}, &block)
        http_call(:get, url, params, &block)
      end

      def post(url, params = {}, &block)
        http_call(:post, url, params, &block)
      end

      def put(url, params = {}, &block)
        http_call(:put, url, params, &block)
      end

      def delete(url, params = {}, &block)
        http_call(:delete, url, params, &block)
      end

      def http_call(method, url, call_options = {}, &block)
        _options = call_options 
        _options.merge! self.default_url_options || {}

        url += self.extension if self.extension
        url = complete_url(url) if self.root
        
        Maglev::API.http_call(method, url, _options, &block)
      end
    end
  end
end