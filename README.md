# README

Demo app for a document library service that will send updates to subscribing customers in order for the subscribed document(s) to be automatically updated in their own database.

When a document is updated on this application, it will send a POST request to the endpoint defined in the customer record, for each customer who is subscribed to that document.
- To be subscribed to a document means that a webhook is defined which links the customer to the document. The webhook record includes a unique identifying token.
- It is up to the customer application as to whether it will create the document if the POST request is received and there is no matching record. For demonstration purposes, the demo customer app will `create_or_update`

This application uses delayed_job_active_record / delayed_job to send the webhooks in the background. delayed_job uses the database to store the list of jobs, so Redis is not required. In order continuously poll for jobs, run
```
$ bundle exec rake jobs:work
```
- https://github.com/collectiveidea/delayed_job_active_record
- https://github.com/collectiveidea/delayed_job

Documents are saved to AWS S3 using the AWS SDK. Keys are saved in the Rails credentials file.

Webhooks are sent using Faraday

Authentication is deliberately left unimplemented. It would be required for real world use.

Use images as the documents.