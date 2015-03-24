require 'rest_client'
require 'json'

#
# curl -i -d 'login=ben&password=ben' http://localhost:9292/rc/v1/app/login
#
class ApplicationController < Rhoconnect::Controller::AppBase
  register Rhoconnect::EndPoint
  URL =  "http://rho-fat-free.herokuapp.com"
  # URL = "http://localhost:3000"
  AUTH_URL = "#{URL}/authentication"

  post "/login", :rc_handler => :authenticate,
                 :deprecated_route => {:verb => :post, :url => ['/application/clientlogin', '/api/application/clientlogin']} do
    login = params[:login]
    password = params[:password]

    # puts "#{login}:#{password}"
    begin
      cookies = {}
      res = RestClient.post(AUTH_URL, { :authentication => {:username => login, :password => password }}.to_json,
          :content_type => :json) do |response, request, result, &block|
            set_cookies =  result.get_fields("Set-Cookie")
            # puts set_cookies
            # puts
            set_cookies.each do |cookie|
              cookie.split(';').each do |pair|
                k,v = pair.split('=')
                cookies[k] = v if k =~ /user_credentials/ || k =~ /_session_id/
              end
            end
            # puts cookies
          end

      if cookies['user_credentials']
        Store.put_value("user:#{login}:user_credentials", cookies['user_credentials'])
        Store.put_value("user:#{login}:_session_id", cookies['_session_id'])
        true
      else
        puts "Invalid credentials!"
        false
      end
    rescue Exception => e
      puts e.message
      puts e
      false
    end
  end

  get "/rps_login", :rc_handler => :rps_authenticate,
                    :login_required => true do
    login = params[:login]
    password = params[:password]
    true # optionally handle rhoconnect push authentication...
  end
end
