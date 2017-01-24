# TODO: Maybe this isn't technically a model
def ProductSet < Array

	def recommend(min_qty: 3, total_price: 50)
		set = self

		# I know this isn't exactly what we're looking for, but this is as close as I can get for now.
		until set.take(3).reduce { |sum, e| sum + e.price } < 50
			set = set.shift
		end


	end

	def self.from_retailer_list(retailers)
		retailers.each do |retailer|
			retailer['products'].each do |product|
				out.push(Product.new(product).tap do |out_product|
					# set associations
					out_product.retailer = Retailer.new(retailer.reject { |k, _v| k == 'products' })
				end)
			end
		end
	end
end
