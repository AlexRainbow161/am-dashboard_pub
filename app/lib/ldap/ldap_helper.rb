require 'net/ldap'
# helper for ldap auth
module Ldap
  class LdapHelper
    class << self
      def login_as(username, password)
        ldap = Net::LDAP.new
        ldap.host = "10.61.0.10"
        ldap.port = 389
        ldap.auth "my\\#{username}", password
        result = ldap.bind_as(base: "dc=my,dc=company,dc=ru",
                              filter: "(sAMAccountName=#{username})",
                              password: password)
        if result
          entry = result.first
          user = {username: username,
                  fullname: entry['displayName'].first,
                  email: entry['mail'].first,
                  role_id: 2}
        else
          false
        end
      end
      def search_by_username(username)
        ldap ||= Net::LDAP.new
        ldap.host = "10.61.0.10"
        ldap.port = 389
        ldap.auth "my\\example", "example_password"
        if ldap.bind
          filter = Net::LDAP::Filter.eq('sAMAccountName', "*#{username}*")
          tree = "dc=my,dc=company,dc=ru"
          attrs  = ['mail', 'displayName', 'sAMAccountName']
          entrys = ldap.search(base: tree, filter: filter, attributes: attrs)
        else
          nil
        end
      end
    end
  end
end