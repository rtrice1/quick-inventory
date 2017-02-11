class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_paper_trail_whodunnit

        def current_user
          @current_user ||= User.find(session[:username]) if session[:username]
        end
        helper_method :current_user

        def user_for_paper_trail
           if session[:username].nil?
              'Public user'
           else
              current_user.username
          end  # or whatever
        end
        def authorize
          if current_user.nil?
                session[:params] = params if params
          else
                session[:params] = nil
          end
          redirect_to login_url, alert: "Not authorized" if current_user.nil?
        end

        def four_oh_four
                flash[:notice] = "Resource not found"
                render "welcome/index"
        end

        def clean_params(params)
                newparams = Hash.new
                ignore_params = ['format','controller','action','id', 'Id']
                params.each do |key, val|
                  unless ignore_params.include? key
                    newparams[key] = val
                  end
                end
                newparams
        end
end
