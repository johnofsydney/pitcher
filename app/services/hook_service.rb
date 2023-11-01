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


    Webhook.where(document: @document).each do |webhook|
      pitch_service = PitchService.new(webhook).delay.call
    end
  end
end
