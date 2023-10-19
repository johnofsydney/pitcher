class HookConductor < ApplicationJob
  queue_as 'pitcher_delayed_job'

  def perform(document_id)
    document   = Document.find(document_id)
    HookService.new(document).call
  end
end