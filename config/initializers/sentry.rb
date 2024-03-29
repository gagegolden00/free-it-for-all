Sentry.init do |config|
  config.dsn = 'https://34622561e14efee432812556188f3da9@o59326.ingest.sentry.io/4506145815134208'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
