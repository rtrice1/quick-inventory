require 'net/ldap'

class User
        include ActiveModel::Model

  attr_accessor :username, :password
  def initialize(attributes={})
    super
  end
  ATTR_SV = {
              :login => :samaccountname,
              :first_name => :givenname,
              :last_name => :sn,
              :email => :mail
            }

  ATTR_MV = {
              :groups => [ :memberof,
                           # Get the simplified name of first-level groups.
                           # TODO: Handle escaped special characters
                           Proc.new {|g| g.sub(/.*?CN=(.*?),.*/, '\1')} ]
            }

        def self.find(username)
                #TODO: figure out how to pull more info from AD in the first place
                usr = self.new
        usr.username = username
                return usr
        end

        def self.authenticate(username, password)
                #do active directory stuff here
                conn = Net::LDAP.new :host => APP_CONFIG['ldap_server'],
                         :port => APP_CONFIG['ldap_port'],
                         :base => APP_CONFIG['ldap_base'],
                         :encryption => APP_CONFIG['ldap_encryption'].to_sym,
                         :auth => { :username => "#{username}@#{APP_CONFIG['ldap_domain']}",
                                    :password => "#{password}",
                                    :method => APP_CONFIG['ldap_connect_method'].to_sym }
      begin
            if conn.bind and user = conn.search(:filter => "sAMAccountName=#{username}").first
                      # TODO: Enable this for enumeration of user data.
                      # self.populate_user_data(user)
                      usr = self.new
                      usr.username = user.name[0].to_s
                      return usr
                    else
                      return false
                    end
      rescue Exception => e
        puts e.to_yaml
            return false
                  end
        end
end
