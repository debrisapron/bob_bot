class RealtimeController < FayeRails::Controller

  observe Message, :after_create do
    RealtimeController.publish('/public_message')
  end
  
end