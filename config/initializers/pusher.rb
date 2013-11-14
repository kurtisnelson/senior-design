require 'pusher'

if ::Rails.env == "development"
  Pusher.app_id = '55244'
  Pusher.key    = 'e6f4f74ff01f5f5800af'
  Pusher.secret = ENV['PUSHER_SECRET']
end
