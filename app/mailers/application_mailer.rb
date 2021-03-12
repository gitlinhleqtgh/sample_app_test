class ApplicationMailer < ActionMailer::Base
  default from: Settings.user.email.default
  layout Settings.user.email.layout
end
