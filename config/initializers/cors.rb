Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'editor.swagger.io'
    resource '*',
      headers: :any,
      methods: %i(get post put patch delete options head)
  end
end