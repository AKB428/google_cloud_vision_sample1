require 'httpclient'
require 'base64'
require 'json'
require 'pp'

def request_json(content)
  {
      requests: [{
                     image: {
                         content: content
                     },
                     features: [{
                                    type: 'WEB_DETECTION',
                                    maxResults: 30
                                }]
                 }]
  }.to_json
end

def request(file_path)
  endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{@key}"
  http_client = HTTPClient.new
  content = Base64.strict_encode64(File.new(file_path, 'rb').read)
  response = http_client.post_content(endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
  JSON.parse(response)['responses'].first
end

file_path = ARGV[0]
@key = ARGV[1]

pp request(file_path)