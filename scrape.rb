# SCRAPING a metal-archives.com list #
require 'nokogiri'
require 'open-uri'
require 'net/http'
require 'json'

def upload(band_info)
  # add band info to parse.com
  artist_parse_uri = URI.parse("https://api.parse.com/1/classes/Artist")
  artist_https = Net::HTTP.new(artist_parse_uri.host, artist_parse_uri.port)
  artist_https.use_ssl = true
  artist_req = Net::HTTP::Post.new(artist_parse_uri.path, {'Content-Type' =>'application/json'})
  artist_req['X-Parse-Application-Id'] = 'rtXmpWUjbxjSNVejzk17KdwO2dx8fgT9TAolbBG4'
  artist_req['X-Parse-REST-API-Key'] = File.read('./api.key')
  artist_req['Content-Type: application/json']
  artist_req.body = band_info.to_json
  artist_res = artist_https.request(artist_req)

  puts "#{band_info}"
  puts "Response #{artist_res.code} #{artist_res.message}: #{artist_res.body}"
  puts "-" * 170
end


bands_json = File.read("./IN.json")
bands = JSON.parse(bands_json)['aaData']
puts "Found #{bands.length} bands..."
bands[0..0].each do |band|
  band_name = Nokogiri::HTML.parse(band[0]).text
  band_genres = band[1]
  band_location = band[2]
  band_status = Nokogiri::HTML.parse(band[3]).text.downcase == "active" ? "ACTIVE" : "INACTIVE"
  band_detail_url = Nokogiri::HTML.parse(band[0]).xpath('//a/@href').text

  band_info = {'name' => band_name, 'primary_genre' => 'metal', 'location' => band_location, 'genres' => band_genres, 'active' => (band_status == 'ACTIVE')}

  # get band image
  puts band_detail_url
  data = Nokogiri::HTML(open(band_detail_url))
  band_image = data.at_css('#logo')

  if band_image
   band_logo_image_url = band_image.xpath('@href').text
    
    # add the image file to parse.com
    image_parse_uri = URI.parse("https://api.parse.com/1/files/logo.jpeg")
    image_https = Net::HTTP.new(image_parse_uri.host, image_parse_uri.port)
    image_https.use_ssl = true
    image_req = Net::HTTP::Post.new(image_parse_uri.path, {'Content-Type' =>'image/jpeg'})
    image_req['X-Parse-Application-Id'] = 'rtXmpWUjbxjSNVejzk17KdwO2dx8fgT9TAolbBG4'
    image_req['X-Parse-REST-API-Key'] = File.read('./api.key')
    image_req['Content-Type: application/json']
    image_req.body = Net::HTTP.get_response(URI.parse(band_logo_image_url)).body
    image_res = image_https.request(image_req)

    if image_res.code == '201'
      image_response = JSON.parse(image_res.body)
      image_name = image_response['name']
      # merge
      band_info.merge!('logo_image_url' => band_logo_image_url, 'logo_image_file' => {'name' => image_name, '__type' => 'File'}) 
    end
  end

  band_id = band_detail_url.split('/').last
  
  # discography 
  # 
  # merge
  discography = Nokogiri::HTML(open("http://www.metal-archives.com/band/discography/id/#{band_id}/tab/all"))
  discography.xpath("//table/tbody/tr").each do |tr|
    album_info = tr.css('td').map{|x| x}
    album_name = album_info[0].text
    album_link = album_info[0].at_css('a')['href']
    album_type = album_info[1].text
    album_year = album_info[2].text
    #puts album_link
    puts album_name
    #puts album_type
    #puts album_year

    album_tracks = Nokogiri::HTML(open(album_link))
    
    album_tracks.css(".wrapWords").each do |track|
      puts track.text.gsub("\n","").gsub("\t","")
    end
    
    # albums.each do |album|
    #   puts album.inspect
    #   # get tracks
      
    # end
  end
  

  # band stats
  band_stats = data.at_css('#band_stats').xpath('//dd')
  band_country = band_stats[0].text
  band_country_code = band_stats[0].children[0]['href'].split('/').last
  band_formed = band_stats[3].text
  band_label = band_stats[6].children[0].text
  band_members = data.at_css('#band_tab_members_current').css('.lineupRow').map{|m| [m.at_css('a').text, m.css('td')[1].text.gsub("\n","").gsub("\t","")]}

  # merge
  band_info.merge!('country' => band_country, 'country_code' => band_country_code , 'year' => band_formed, 'label' => band_label, 'members' => band_members)

  # related links

  related_data = Nokogiri::HTML(open("http://www.metal-archives.com/link/ajax-list/type/band/id/#{band_id}"))
  related_links = related_data.at_css("#band_links_Official").xpath("//tr/td/a").inject({}) {|h, x| h[x.text] = x['href']; h} rescue nil

  puts related_links  

  facebook_regex = /(?:https?:\/\/)?(?:www\.)?facebook\.com\/(?:(?:\w)*#!\/)?(?:pages\/)?(?:[\w\-]*\/)*?(\/)?([\w\-\.]*)/
  facebook_username = related_links['Facebook'].match(facebook_regex) rescue nil
  # merge
  band_info.merge!('facebook_username' => facebook_username[2]) unless facebook_username.nil?
  puts facebook_username

  soundcloud_regex = /(?:https?:\/\/)?(?:www\.)?soundcloud\.com\/(?:(?:\w)*#!\/)?(?:[\w\-]*\/)*?(\/)?([\w\-\.]*)/
  soundcloud_username = related_links['SoundCloud'].match(soundcloud_regex) rescue nil
  # merge
  band_info.merge!('soundcloud_username' => soundcloud_username[2]) unless soundcloud_username.nil?
  puts soundcloud_username
  
  # upload(band_info)
end

