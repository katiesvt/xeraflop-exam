class Product < Hash
  def initialize(hash)
		merge!(hash)
	end

  def avg_thc
    self['thc_range'].inject(:+).to_f / self['thc_range'].size
  end

  def avg_cbd
    self['cbd_range'].inject(:+).to_f / self['cbd_range'].size
  end

	# TODO: support more than just g
	def price_per_g
		self['price'].to_f / self['unit_weight'].to_f
	end
end
