#http://qiita.com/icb54615/items/f83d0294528b660e9383
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
                                    type: "LABEL_DETECTION",
                                    maxResults: 10
                                }]
                 }]
  }.to_json
end

def result_parse(response)
  result = JSON.parse(response)['responses'].first
  #label = result['labelAnnotations'].first
  #"これは、#{label['description']}です。"
end

def request(file_path)
  endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{@key}"

  p endpoint_uri

  http_client = HTTPClient.new
  content = Base64.strict_encode64(File.new(file_path, 'rb').read)

   content
  response = http_client.post_content(endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
  result_parse(response)
end

file_path = ARGV[0]
@key = ARGV[1]

pp request(file_path)