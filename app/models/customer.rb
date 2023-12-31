class Customer < ApplicationRecord
  has_many :webhooks

  validates :name, presence: true
  validates :url, presence: true, format: { with: URI.regexp }
  validates :endpoint, presence: true
  enum strategy: { hotlink: 'hotlink', bucket: 'bucket', binary: 'binary' }

  require 'faraday'

  def server_online?(url = self.url)
    begin
      response = Faraday.head(url)
      if response.status == 200
        puts "Server is online (Status: #{response.status})"
        true
      else
        puts "Server is offline (Status: #{response.status})"
        false
      end
    rescue Faraday::ConnectionFailed
      puts "Server is offline (Connection failed)"
      false
    rescue StandardError => e
      puts "An error occurred: #{e.message}"
    end
  end
end
