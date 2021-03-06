Rails.application.config.middleware.insert_before 0, Rack::Cors do
   allow do
    origins 'http://localhost:3000'

    resource '*',
      headers: :any,
      methods: [:get, :put, :post, :patch, :delete, :options]
  end
end
