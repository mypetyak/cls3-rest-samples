require 'rest-client'
require 'json'
require 'launchy'

client_id = '6fb14207a77abcb000d9e0f3d133902a60ae0bb1924f5b33d9610a198b439938'
client_secret = '0379d766923739859830cf94d8ad0a78607854f2e9fa945367708a4030cf2cb1'

response = RestClient.post 'http://localhost:3000/api/v1/oauth/token', {
    grant_type: 'client_credentials',
    client_id: client_id,
    client_secret: client_secret
}, :accept => :json

access_token = JSON.parse(response)['access_token']
response = RestClient.post(
  'http://localhost:3000/api/v1/documents',
  {:document_type => "A", :acquisition_title => "Title1", :document_number => 1233, :document_date => "2014-06-05"}.to_json,
  :content_type => :json, :accept => :json, :Authorization => "Bearer #{access_token}"
)

response_json = JSON.parse(response)
document_id = response_json['document']['id']

response = RestClient.post(
  'http://localhost:3000/api/v1/interviews',
  {:document_id => document_id}.to_json,
  :content_type => :json, :accept => :json, :Authorization => "Bearer #{access_token}"
)

interview_id = JSON.parse(response)['interview_launcher']['id']

puts "http://localhost:3000/api/v1/interviews/#{interview_id}/launch_url"
response = RestClient.get(
  "http://localhost:3000/api/v1/interviews/#{interview_id}/launch_url",
  :content_type => :json, :accept => :json, :Authorization => "Bearer #{access_token}"
)

puts "URL to use is #{JSON.parse(response)['launch_url']}"
Launchy.open("#{JSON.parse(response)['launch_url']}")

puts "http://localhost:3000/api/v1/documents/#{document_id}/"
response = RestClient.get(
  "http://localhost:3000/api/v1/documents/#{document_id}/",
  :content_type => :json, :accept => :json, :Authorization => "Bearer #{access_token}"
)
puts response
