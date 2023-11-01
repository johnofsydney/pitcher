class PitchService
  attr_reader :webhook

  def self.call(webhook)
    new(webhook).call
  end

  def initialize(webhook)
    @webhook = webhook
    @document = webhook.document
  end

  def call
    return unless webhook.customer.server_online?
    strategy = :hotlink

    # construct a payload of basic doc params required
    base_payload = {
      token: webhook.token,
      description: @document.description
    }

    # adjust the payload according to the strategy
    if webhook.customer.hotlink?
    # if strategy == :hotlink
      payload = base_payload.merge({link: @document.link})
    elsif webhook.customer.bucket?
      pitcher_s3 = S3.new(S3::BUCKET)
      file = pitcher_s3.get_object(key: @document.key).body.read # document from this database / pitcher bucket

      # put the file in the customer bucket
      catcher_s3 = S3.new(webhook.customer.bucket)
      save_results = catcher_s3.put_object(
        key: @document.key,
        body: file
      )

      payload = base_payload.merge({link: save_results[:address]})
    elsif webhook.customer.binary?
      raise NotImplementedError
    end

    # response
    post_service = PostService.new(webhook.customer.url, webhook.customer.endpoint, payload)
    post_service.delay.call
  end
end