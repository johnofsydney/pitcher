# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Document.destroy_all
Customer.destroy_all
Webhook.destroy_all

document_seed_records = [
  {
    description: "Lithium Ion MSDS",
    link: "https://via.placeholder.com/150",
    expiry_date: Date.new(2023, 6, 1)
  },
  {
    description: "Pricelss Fine Art",
    link: "https://via.placeholder.com/250",
    expiry_date: Date.new(2023, 5, 1)
  },
  {
    description: "Recipe for Dynamite",
    link: "https://via.placeholder.com/350",
    expiry_date: Date.new(2023, 4, 1)
  },
  {
    description: "Recipe for Salad",
    link: "https://via.placeholder.com/450",
    expiry_date: Date.new(2023, 3, 1)
  },
  {
    description: "Secret Financial Documents",
    link: "https://via.placeholder.com/550",
    expiry_date: Date.new(2023, 2, 1)
  }
]

customer_seed_records = [
  {
    name: "Acme Corp", # subscribes to everything
    url: 'localhost:3001',
    endpoint: '/documents',
    bucket: 'acme-bucket-100'
  },
  {
    name: "Globex Corp", # subscribes to fine art
    url: 'localhost:3002',
    endpoint: '/glob',
    bucket: 'globex-bucket'
  },
  {
    name: "Soylent Corp", # subscribes to salad and dynamite
    url: 'localhost:3003',
    endpoint: '/soy-boy',
    bucket: 'soylent-bucket'
  }
]

Document.create(document_seed_records)
Customer.create(customer_seed_records)

Webhook.create(
  customer: Customer.find_by(name: "Acme Corp"),
  document: Document.find_by(description: "Lithium Ion MSDS"),
  token: 'ABC123'
)

Webhook.create(
  customer: Customer.find_by(name: "Acme Corp"),
  document: Document.find_by(description: "Priceless Fine Art"),
  token: 'ASD234'
)

Webhook.create(
  customer: Customer.find_by(name: "Acme Corp"),
  document: Document.find_by(description: "Recipe for Dynamite"),
  token: 'DGF543'
)

Webhook.create(
  customer: Customer.find_by(name: "Acme Corp"),
  document: Document.find_by(description: "Recipe for Salad"),
  token: 'KOL987'
)

Webhook.create(
  customer: Customer.find_by(name: "Acme Corp"),
  document: Document.find_by(description: "Secret Financial Documents"),
  token: 'YOB123'
)

Webhook.create(
  customer: Customer.find_by(name: "Globex Corp"),
  document: Document.find_by(description: "Priceless Fine Art"),
  token: 'X7Y5'
)

Webhook.create(
  customer: Customer.find_by(name: "Soylent Corp"),
  document: Document.find_by(description: "Recipe for Dynamite"),
  token: 'BGO8'
)

Webhook.create(
  customer: Customer.find_by(name: "Soylent Corp"),
  document: Document.find_by(description: "Recipe for Salad"),
  token: 'FHG9'
)
