class Product < OpenStruct
  def avg_thc
    out_product['thc_range'].inject(:+).to_f / out_product['thc_range'].size
  end

  def avg_cbd
    out_product['cbd_range'].inject(:+).to_f / out_product['cbd_range'].size
  end

	# TODO: support more than just g
	def price_per_g
		out_product['price'].to_f / out_product['unit_weight'].to_f
	end
end
