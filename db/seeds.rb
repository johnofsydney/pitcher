# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


Document.destroy_all

seed_records = [
  {
    description: "Document 1",
    link: "https://via.placeholder.com/150",
    expiry_date: Date.new(2023, 6, 1)
  },
  {
    description: "Document 2",
    link: "https://via.placeholder.com/250",
    expiry_date: Date.new(2023, 5, 1)
  },
  {
    description: "Document 3",
    link: "https://via.placeholder.com/350",
    expiry_date: Date.new(2023, 4, 1)
  },
  {
    description: "Document 4",
    link: "https://via.placeholder.com/450",
    expiry_date: Date.new(2023, 3, 1)
  },
  {
    description: "Document 5",
    link: "https://via.placeholder.com/550",
    expiry_date: Date.new(2023, 2, 1)
  }
]

Document.create(seed_records)