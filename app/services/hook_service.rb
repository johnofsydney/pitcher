class HookService
  def self.call(document)
    new(document).call
  end

  def initialize(document)
    @document = document
  end

  def call
    # return unless @document.link.present?
    # return unless @document.link_changed?

    payload = {
      text: "New document uploaded: #{@document}"
    }.to_json

    HTTParty.post(
      ENV['SLACK_WEBHOOK_URL'],
      body: payload,
      headers: { 'Content-Type' => 'application/json' }
    )
  end
end