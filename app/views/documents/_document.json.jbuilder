json.extract! document, :id, :description, :expiry_date, :link, :created_at, :updated_at
json.url document_url(document, format: :json)
