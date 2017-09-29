class InvitationMailer < ApplicationMailer
  def invitation_email(invitation)
    @invitation = invitation
    @home = invitation.home
    mail(
      to: @invitation.email,
      subject: "Join #{@home.name} on Whare Hauora"
    )
  end
end
