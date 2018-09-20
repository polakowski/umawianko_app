class ApplicationClient
  def self.base_url(url)
    @@base_url = url
  end

  private

  def get(url, content_type:, root_key: nil, params: nil, headers: {})
    response = HTTParty.get(
      build_full_url(url),
      query: params,
      headers: headers.merge(
        'Content-Type' => content_type
      )
    )

    handle_response(response, root_key)
  end

  def base_url
    @@base_url
  end

  def build_full_url(url)
    "#{base_url}#{url}"
  end

  def parse_response(response)
    JSON.parse(response.body).deep_symbolize_keys
  end

  def handle_response(response, root_key = nil)
    parsed_response = parse_response(response)

    return parsed_response[root_key.intern] if root_key.present? && response.ok?

    parsed_response
  end
end
