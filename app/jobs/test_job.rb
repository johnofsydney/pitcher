# app/jobs/your_job.rb
class TestJob < ApplicationJob
  queue_as 'pitcher_default' # AWS SQS Queue

  def perform(document_id)
    document   = Document.find(document_id)
    # perform your task on resource ...
    p "document: #{document.description}"
    100
  end
end