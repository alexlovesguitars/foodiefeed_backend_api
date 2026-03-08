Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3000' # Update this to your frontend URL in production
    resource '*',
      headers: :any,
      methods: [:get, :post, :patch, :put, :delete, :options],
      credentials: true
  end
end
