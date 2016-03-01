#http://qiita.com/icb54615/items/f83d0294528b660e9383
require 'httpclient'
require 'base64'
require 'json'
require 'pp'


=begin
TYPE_UNSPECIFIED	Unspecified feature type.
FACE_DETECTION	Run face detection.
LANDMARK_DETECTION	Run landmark detection.
LOGO_DETECTION	Run logo detection.
LABEL_DETECTION	Run label detection.
TEXT_DETECTION	Run OCR.
SAFE_SEARCH_DETECTION	Run various computer vision models to compute image safe-search properties.
IMAGE_PROPERTIES	Compute a set of properties about the image (such as the image's dominant colors).
=end

def request_json(content)
  {
      requests: [{
                     image: {
                         content: content
                     },
                     features: [{
                                    type: "TEXT_DETECTION",
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