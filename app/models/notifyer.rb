class Notifyer < ActionMailer::Base
  def signup_code(email, code)
    recipients email
    from 'noreply@fucksheep.org'
    subject 'My foot hurts.'
    body :code => code
  end
end
