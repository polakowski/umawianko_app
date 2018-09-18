class ApplicationClient
  def self.base_url(url)
    @@base_url = url
  end

  private

  def get(url, params: nil, headers: nil)
    response = HTTParty.get(
      build_full_url(url),
      query: params,
      headers: build_headers(headers, :get)
    )

    handle_response(response)
  end

  def build_headers(headers, action)
    default_headers(action).tap do |defaults|
      defaults.merge!(headers) if headers
    end
  end

  def build_full_url(url)
    "#{@@base_url}#{url}"
  end

  def handle_response(response, root_key = nil)
    parsed_response = parse_response(response)
    root_key ? parsed_response[root_key] : parsed_response
  end

  def parse_response(response)
    response.as_json
  end

  def default_headers(action)
    { 'Content-Type' => content_type_for(action) }
  end

  def default_content_types
    {}
  end

  def default_content_type
    'application/json, charset=utf-8'
  end

  def content_type_for(action)
    default_content_types.fetch(action) { default_content_type }
  end
end
