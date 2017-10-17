require 'httpclient'
require 'base64'
require 'json'
require 'pp'
require 'fileutils'

def request_json(content)
  {
      requests: [{
                     image: {
                         content: content
                     },
                     features: [{
                                    type: 'WEB_DETECTION',
                                    maxResults: 20
                                }]
                 }]
  }.to_json
end

def request(file_path, key)
  endpoint_uri = "https://vision.googleapis.com/v1/images:annotate?key=#{key}"
  http_client = HTTPClient.new
  content = Base64.strict_encode64(File.new(file_path, 'rb').read)
  response = http_client.post_content(endpoint_uri, request_json(content), 'Content-Type' => 'application/json')
  JSON.parse(response)['responses'].first
end

# ママか判定する
def match_mama(response, mama_list)
  response['webDetection']['webEntities'].each do |entity|
    mama_list.each do |name|
      puts name
     # puts entity['description']
      return name if entity['description'] == name
      return name if entity['description'] =~ /#{name}/
    end
  end
  nil
end

directory = ARGV[0]
api_key = ARGV[1]

# 今日の嫁を定義する
mama_list = %w[Chino Inori Meteora R.E.M.]

# ディレクトリがなければ作る
mama_list.each do |name|
  path = File.join(directory, name)
  FileUtils.mkdir_p(path) unless FileTest.exist?(path)
end

# ディレクトリのファイルを走査
Dir.glob(directory + '*').each do |file_path|
  next if File::ftype(file_path) == 'directory'

  puts file_path
  response = request(file_path, api_key)
  #pp response

  # responseを走査
  match_name = match_mama(response, mama_list)
  if match_name != nil
    puts "#{file_path} が #{match_name} と合致しました"
    # マッチしたらママフォルダに移動する
    FileUtils.mv(file_path, File.join(directory, match_name, File.basename(file_path)))
  end

end

