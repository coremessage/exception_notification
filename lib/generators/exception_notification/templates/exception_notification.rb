<% if options.sidekiq? %>
require 'exception_notification/sidekiq'
<% end %>
<% if options.resque? %>
require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'exception_notification/resque'

Resque::Failure::Multiple.classes = [Resque::Failure::Redis, ExceptionNotification::Resque]
Resque::Failure.backend = Resque::Failure::Multiple
<% end %>

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, AbstractController::ActionNotFound and ActionController::RoutingError are already added.
  # config.ignored_exceptions += %w{ActionView::TemplateError CustomError}

  # Notifiers =================================================================

  # Email notifier sends notifications by email.
  config.add_notifier :email, {
    :email_prefix         => "[ERROR] ",
    :sender_address       => %{"Notifier" <notifier@example.com>},
    :exception_recipients => %w{exceptions@example.com}
  }

  # Campfire notifier sends notifications to your Campfire room. Requires 'tinder' gem.
  # config.add_notifier :campfire, {
  #   :subdomain => 'my_subdomain',
  #   :token => 'my_token',
  #   :room_name => 'my_room'
  # }

  # Webhook notifier sends notifications over HTTP protocol. Requires 'httparty' gem.
  # config.add_notifier :webhook, {
  #   :url => 'http://example.com:5555/hubot/path',
  #   :http_method => :post
  # }

end
