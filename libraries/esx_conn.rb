class ESXConnection
  def initialize
    # TODO: this does not belong here and should be an InSpec target information
    # can I extend this from InSpec
    # INSPEC_ESX_CONN='vsphere://root:vmwarevmware@192.168.10.139'
    connection = URI(ENV['INSPEC_ESX_CONN'])

    if connection.scheme != 'vsphere' ||
       connection.host.nil? ||
       connection.password.nil? ||
       connection.user.nil?
      raise 'Please use vsphere://username:password@host'
    end

    @conn_opts = {
      host: connection.host,
      user: connection.user,
      password: connection.password,
      insecure: true,
    }
    require 'rbvmomi'
  end

  def connection
    return @conn if defined?(@conn)
    @conn = RbVmomi::VIM.connect @conn_opts
  end
end
