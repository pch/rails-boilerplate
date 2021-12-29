Geocoder.configure(
  ip_lookup: :geoip2,
  geoip2: {
    file: Rails.configuration.app.fetch(:geocoding).fetch(:maxmind_geolite2_file)
  }
)
