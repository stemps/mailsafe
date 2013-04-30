class Railtie < Rails::Railtie
  initializer "mailsafe.initialize" do
    Mail.register_interceptor(Mailsafe::ChangeSubjectInterceptor)
    Mail.register_interceptor(Mailsafe::RerouteInterceptor)
  end
end
