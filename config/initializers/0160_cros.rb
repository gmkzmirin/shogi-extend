Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    if Rails.env.production?
      origins 'tk2-221-20341.vs.sakura.ne.jp'
    else
      origins '*'
    end

    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end
