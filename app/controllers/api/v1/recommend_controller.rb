class Api::V1::RecommendController < Api::V1::V1Controller
  def recommend_products
    retailers = restrict_retailer_set(geo_product_search(params['zipCode']))
    products = restrict_product_set(ProductSet.from_retailer_list(retailers))

    result = recommend(products)

    render json: result
  end

  private

  # Restrict retailers based on distance
  def restrict_retailer_set(set)
    set.select { |retailer| retailer['distance'].to_f < params['maxRadius'].to_f }
  end

  # Restrict products to workable set
  def restrict_product_set(set)
    set.select! { |product| product.price < 50 }
    # TODO: If unit isn't grams our ratio will be way off
    set.sort_by! { |product| product.price_per_g / product.avg_thc }
  end

  def geo_product_search(zipcode)
    coords = get_coords(zipcode)

    query_url = 'https://admin.duberex.com/products/geo_search.json?' \
                "gps[]=#{coords['lat']}&" \
                "gps[]=#{coords['lng']}&" \
                'searchText=flowers'

    Rails.logger.debug("Duberex API call: #{query_url}")

    JSON.parse(Faraday.get(query_url).body)
  end

  def get_coords(address)
    json = JSON.parse(
      google_maps(
        'https://maps.googleapis.com/maps/api/geocode/json',
        address: address
      )
    )

    json['results'][0]['geometry']['location']
  end
end
