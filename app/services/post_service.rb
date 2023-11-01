class PostService
  attr_reader :url, :endpoint, :payload

  # def self.call(url:, endpoint:, payload:)
  #   new(url:, endpoint:, payload:).call
  # end

  def initialize(url, endpoint, payload)
    @url = url
    @endpoint = endpoint
    @payload = payload
  end

  def call
    # https://httpbin.org/post

    # post payload to the customer endpoint
    conn = Faraday.new(
      url: url,
      headers: {'Content-Type' => 'application/json'}
    )

    begin
      response = conn.post(endpoint) do |req|
        req.body = payload.to_json
      end
    rescue Faraday::ConnectionFailed => e
      response = OpenStruct.new(body: e.inspect, status: 500)
    end
  end
end