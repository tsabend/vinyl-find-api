class DiscogsMarketplace

  def self.release_listings(release_id)
    uri = URI.parse("http://api.discogs.com/marketplace/search?release_id=#{release_id}")
    response = Net::HTTP.get_response(uri)
    body = JSON.parse(response.body, symbolize_names: true)

  end

  def self.price(release_id)
    listings = release_listings(release_id)
    return "N/A" if listings.empty?
    sum = listings.reduce(Money.new(0, "USD")) do |sum, listing|
      sum + Money.new(string_to_money(listing[:price]), listing[:currency]).as_us_dollar
    end
    ((sum.cents / listings.size) / 100.0).to_s
  end

  def self.string_to_money(str)
    str.gsub(/\D/, "").to_i
  end

end


# an individual listing has this object structure
 # :release_id=>371293,
 # :ships_from=>"United States",
 # :title=>"Strokes, The - Is This It (CD, Album)",
 # :price=>"$4.89",
 # :currency=>"USD",
 # :sleeve_condition=>"Near Mint (NM or M-)",
 # :id=>219633169,
 # :condition=>"Near Mint (NM or M-)"}
