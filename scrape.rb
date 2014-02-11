# SCRAPING a metal-archives.com list #
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'json'

bands_json = File.read("./IN.json")
bands = JSON.parse(bands_json)['aaData']
puts "Found #{bands.length} bands..."
bands.each do |band|
  band_name = Nokogiri::HTML.parse(band[0]).text
  band_genres = band[1]
  band_location = band[2]
  band_status = Nokogiri::HTML.parse(band[3]).text.downcase == "active" ? "ACTIVE" : "INACTIVE"
  band_detail_url = Nokogiri::HTML.parse(band[0]).xpath('//a/@href').text


  # get band image
  puts band_detail_url
  data = Nokogiri::HTML(open(band_detail_url))
  band_image = data.at_css('#logo')

  band_logo_image_url = band_image.xpath('@href').text if band_image

  band_info = {'name' => band_name, 'primary_genre' => 'metal', 'location' => band_location, 'genres' => band_genres, 'active' => (band_status == 'ACTIVE'), 'logo_image_url' => band_logo_image_url}

  # add to parse.com
  parse_uri = URI.parse("https://api.parse.com/1/classes/Artist")
  https = Net::HTTP.new(parse_uri.host,parse_uri.port)
  https.use_ssl = true
  req = Net::HTTP::Post.new(parse_uri.path, {'Content-Type' =>'application/json'})
  req['foo'] = 'bar'
  req['X-Parse-Application-Id'] = 'rtXmpWUjbxjSNVejzk17KdwO2dx8fgT9TAolbBG4'
  req['X-Parse-REST-API-Key'] = File.read('./api.key')
  req['Content-Type: application/json']
  req.body = band_info.to_json
  res = https.request(req)

  puts "Response #{res.code} #{res.message}: #{res.body}"
  puts "#{band_info}"
  puts "-" * 170
end


# url = "http://www.metal-archives.com/lists/IN"

# data = Nokogiri::HTML(open(url))

# bands = data.css('#bandListCountry')
# puts bands.children[0].inspect
# bands.each do |band|
#   puts band.css.inspect
# end
