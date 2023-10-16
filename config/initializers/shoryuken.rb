Shoryuken.sqs_client = Aws::SQS::Client.new(
  region: 'ap-southeast-2',
  access_key_id: Rails.application.credentials.aws[:access_key_id],
  secret_access_key: Rails.application.credentials.aws[:secret_access_key]
)