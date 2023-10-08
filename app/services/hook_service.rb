require 'securerandom'

class HookService
  def self.call(document)
    new(document).call
  end

  def initialize(document)
    @document = document
  end

  def call
    pitcher_s3 = S3.new(S3::BUCKET)
    file = pitcher_s3.get_object(key: @document.key).body.read # document from this database / pitcher bucket

    Webhook.where(document: @document).each do |webhook|
      next unless webhook.customer.server_online?

      # put the file in the customer bucket
      catcher_s3 = S3.new(webhook.customer.bucket)
      save_results = catcher_s3.put_object(
        key: @document.key,
        body: file
      )

      # construct a payload to send to the customer application, linking the record in their database to the new file in their bucket
      payload = {
        token: webhook.token,                 # required
        link: save_results[:address],         # do send this link, but be aware that it could be constructed in the customer app using the bucket and key
        bucket: webhook.customer.bucket,
        key: @document.key
      }

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
    end



    # get address to send to
    # copy S3 to S3
    # get new address for file in customer bucket
    # post payload to customer endpoint
  end
end