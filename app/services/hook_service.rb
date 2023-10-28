require 'securerandom'

class HookService
  def self.call(document)
    new(document).call
  end

  def initialize(document)
    @document = document
  end

  def call
    # TODO: different strategies, orchestrated from this class, using customer preference
    pitcher_s3 = S3.new(S3::BUCKET)
    file = pitcher_s3.get_object(key: @document.key).body.read # document from this database / pitcher bucket

    Webhook.where(document: @document).each do |webhook|
      next unless webhook.customer.server_online?
      strategy = :hotlink

      # construct a payload of basic doc params required
      base_payload = {
        token: webhook.token,
        description: @document.description
      }

      # adjust the payload according to the strategy
      if strategy == :hotlink
        payload = base_payload.merge({link: @document.link})
      elsif strategy == :aws_bucket
        # put the file in the customer bucket
        catcher_s3 = S3.new(webhook.customer.bucket)
        save_results = catcher_s3.put_object(
          key: @document.key,
          body: file
        )

        payload = base_payload.merge({link: save_results[:address]})
      elsif strategy == :send_binary
        3
      end

      # https://httpbin.org/post

      # post payload to the customer endpoint
      conn = Faraday.new(
        url: webhook.customer.url,
        headers: {'Content-Type' => 'application/json'}
      )

      begin
        response = conn.post(webhook.customer.endpoint) do |req|
          req.body = payload.to_json
        end
      rescue Faraday::ConnectionFailed => e
        response = OpenStruct.new(body: e.inspect, status: 500)
      end

      puts response.body

      response
    end
  end
end
