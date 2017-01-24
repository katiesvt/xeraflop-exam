# TODO: Maybe this isn't technically a model
class ProductSet < Array
	def recommend(min_qty: 5, total_price: 50)
		set = self

		# TODO: Force multiple stores!

		# I know this isn't exactly what we're looking for, but this is as close as I can get for now.
		until set.take(min_qty).reduce(0) { |sum, e| sum + e["price"].to_f } < total_price
			Rails.logger.debug("First #{min_qty} " + set.take(min_qty).reduce(0) { |sum, e| sum + e["price"].to_f }.to_s)
			set = set.drop(1)
		end

		set.take(min_qty)
	end

	def self.from_retailer_list(retailers)
		ProductSet.new.tap do |out|
			retailers.each do |retailer|
				retailer['products'].each do |product|
					out.push(Product.new(product).tap do |out_product|
						# set associations
						out_product['retailer'] = Retailer.new(retailer.reject {|k| k == 'products'})
					end)
				end
			end
		end
	end
end
