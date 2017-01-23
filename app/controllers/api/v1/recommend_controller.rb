class Api::V1::RecommendController < Api::V1::V1Controller
  def recommend_products
    # Restrict based on distance
    result = geo_product_search(params["zipCode"])
      .select { |retailer| retailer["distance"].to_f < params["maxRadius"].to_f }

    # TODO: If unit isn't grams our ratio will be way off
    result = invert_retailers_and_products(result)
      .select { |product| product["price"] < 50 }
      .sort_by { |product| product["price_per_g"] / product["avg_thc"] }

    render json: result
  end

  private

  def invert_retailers_and_products(in_array)
    [].tap do |out|
      in_array.each do |retailer|
        retailer["products"].each do |product|
          out.push({}.merge(product).tap do |out_product|
            out_product["retailer"] = retailer.reject { |k, v| k == "products" }
            out_product["avg_thc"] = (out_product["thc_range"].inject(:+).to_f / out_product["thc_range"].size)
            out_product["avg_cbd"] = (out_product["cbd_range"].inject(:+).to_f / out_product["cbd_range"].size)
            out_product["price_per_g"] = (out_product["price"].to_f / out_product["unit_weight"].to_f)
          end)
        end
      end
    end
  end

  def geo_product_search(zipcode)
    coords = get_coords(zipcode)

    options = {
      "gps[]" => coords["lat"],
      "gps[]" => coords["lng"],
      "searchText" => "flowers"
    }

    query_url = "https://admin.duberex.com/products/geo_search.json?" +
      "gps[]=#{coords["lat"]}&" +
      "gps[]=#{coords["lng"]}&" +
      "searchText=flowers"

    Rails.logger.debug("Duberex API call: #{query_url}")

    JSON.parse(Faraday.get(query_url).body)
  end

  def get_coords(address)
    json = JSON.parse(
      google_maps("https://maps.googleapis.com/maps/api/geocode/json", { address: address }).body
    )

    json["results"][0]["geometry"]["location"]
  end
end
