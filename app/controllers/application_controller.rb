class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def google_maps(url, options)
    options.reverse_merge!({
      "key" => ENV['GOOGLE_MAPS_API_KEY']
    })

    query_url = "#{url}?#{options.to_query}"

    Rails.logger.debug("Google Maps API call: #{query_url}")

    Faraday.get(query_url)
  end
end
