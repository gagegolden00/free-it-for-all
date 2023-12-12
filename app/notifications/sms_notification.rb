# To deliver this notification:
#
# SmsNotification.with(post: @post).deliver_later(current_user)
# SmsNotification.with(post: @post).deliver(current_user)

class SmsNotification < Noticed::Base
  deliver_by :twilio

  def initialize(service_job)
    @service_job = service_job
    super
  end

  def deliver(recipiant)
    @client = twilio_client
    message = @client.messages.create(
      body: message_content,
      to: recipiant,
      from: sender
    )
    puts "#############################"
    puts message.sid
    puts "#############################"
  end

  private

  def message_content
    "You have been assigned to #{@service_job[:service_job].job_number}"
  end

  def twilio_client
    Twilio::REST::Client.new(
      twilio_credentials[:account_sid],
      twilio_credentials[:auth_token]
    )
  end

  def twilio_credentials
    {
      account_sid: 'AC02157ab946b89a80db9c0c646af79464',
      auth_token: 'e2a800e6a7ae37ab8592ac97fd6728c8'
    }
  end

  def sender
    '+18887034392'
  end
end

# @client = Twilio::REST::Client.new(account_sid, auth_token)

# tech = '+18777804236' # virtual twilio phone
# mech_cool = '+18887034392' # verified twilio number
# message = @client.messages.create(
#   body: "
# You have a new job!
# Here are some details
#     details
#   details
# link
# ",
#   from: mech_cool,
#   to: tech,
# )
