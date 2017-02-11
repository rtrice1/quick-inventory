class SessionsController < ApplicationController
        def new
        end

        def create
          if user = User.authenticate(params[:username], params[:password])
            session[:username] = user.username
            if session[:params]
                session[:params].symbolize_keys!
                redirect_to :controller => session[:params][:controller], :action => session[:params][:action], :params => session[:params], notice: "Logged in!"
            else
                redirect_to root_url, notice: "Logged in!"
            end
          else
            flash.now.alert = "Email or password is invalid"
            render "new"
          end
        end

        def destroy
          session[:username] = nil
          session[:params] = nil
          redirect_to root_url, notice: "Logged out!"
        end
end
