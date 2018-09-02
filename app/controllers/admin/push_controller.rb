class Admin::PushController < ApplicationController
  def create
    byebug
    # Webpush.payload_send(
    #   message: 'hello',
    #   endpoint: params[:subscription][:endpoint],
    #   p256dh: params[:subscription][:keys][:p256dh],
    #   auth: params[:subscription][:keys][:auth],
    #   ttl: 24 * 60 * 60,
    #   vapid: {
    #     subject: 'yo',
    #     public_key: ENV['VAPID_PUBLIC_KEY'],
    #     private_key: ENV['VAPID_PRIVATE_KEY']
    #   }
    # )
  end
end
