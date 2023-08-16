json.extract! webhook, :id, :customer_id, :document_id, :customer_url, :created_at, :updated_at
json.url webhook_url(webhook, format: :json)
