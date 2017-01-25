class Api::V1::RecommendController < Api::V1::V1Controller
  def recommend_products
    return head :bad_request unless params_ok?

    retailers = geo_product_search(params['zipCode'])
    restrict_retailer_set(retailers)

    products = ProductSet.from_retailer_list(retailers)
    restrict_product_set(products, params['maxSpend'].to_f)

    result = products.recommend(total_price: params['maxSpend'].to_f)

    Rails.logger.debug(result)

    render json: result
  end

  private

  def params_ok?
    Rails.logger.debug(p(params))
    return false unless params['zipCode']&.length
    return false unless params['maxSpend'] =~ /^\d+$/
    return false unless params['maxRadius'] =~ /^\d+$/

    true
  end

  # Restrict retailers based on distance
  def restrict_retailer_set(set)
    set.select! { |retailer| retailer['distance'].to_f < params['maxRadius'].to_f }
  end

  # Restrict products to workable set
  def restrict_product_set(set, maxPrice)
    set.select! { |product| product['price_f'] < maxPrice }
    # TODO: If unit isn't grams our ratio will be way off
    # TODO: define methods instead of using some symbols and some methods
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
