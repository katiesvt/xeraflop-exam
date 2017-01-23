class Api::V1::RecommendController < Api::V1::V1Controller
  def recommend_products
    render format: :json
  end
end
