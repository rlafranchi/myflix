if Rails.env.production?
  require 'raven'

  Raven.configure do |config|
    config.dsn = 'https://3738733a947e498e97cd68109d87cadf:06f795af723f4a7da6b80074acea29c7@app.getsentry.com/31511'
  end
end
