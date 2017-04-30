Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.full_host = "http://ec2-34-210-2-204.us-west-2.compute.amazonaws.com"
  if ENV['CONSUMER_KEY'].blank? || ENV['CONSUMER_SECRET'].blank?
    warn '*' * 80
    warn 'WARNING: Missing consumer key or secret. First, register an app with Twitter at'
    warn 'https://dev.twitter.com/apps to obtain OAuth credentials. Then, start the server'
    warn 'with the command: CONSUMER_KEY=abc CONSUMER_SECRET=123 rails server'
    warn '*' * 80
  else
    provider :twitter, ENV['CONSUMER_KEY'], ENV['CONSUMER_SECRET']
  end
end