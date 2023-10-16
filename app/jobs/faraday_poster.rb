class FaradayPoster < ApplicationJob
  queue_as 'pitcher_default' # AWS SQS Queue

  def perform(url, endpoint, payload)

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