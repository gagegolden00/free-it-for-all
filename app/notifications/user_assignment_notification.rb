
class UserAssignmentNotification < Noticed::Base
  deliver_by :twilio, credentials: :get_twilio_credentials, format: :format_for_twilio

  param :message

  private

  def get_twilio_credentials
    {
      account_sid: 'AC02157ab946b89a80db9c0c646af79464',
      auth_token: 'e2a800e6a7ae37ab8592ac97fd6728c8',
      phone_number: '+18887034392'
    }
  end

  def format_for_twilio
    {
      Body: params[:message],
      From: '+18887034392',
      To: '+18777804236' 
    }
  end
end
