class ESXConnection
  def initialize
    # TODO: this does not belong here and should be an InSpec target information
    # can I extend this from InSpec

    require 'rbvmomi'

    # INSPEC_ESX_CONN='vsphere://root:vmwarevmware@192.168.10.139'
    connection_string = ENV['INSPEC_ESX_CONN']
    if connection_string.nil?
      puts 'Please use vsphere://username:password@host'
      return
    end

    connection = URI(connection_string)
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
  end

  def connection
    return @conn if defined?(@conn)
    @conn = RbVmomi::VIM.connect @conn_opts
  rescue RuntimeError
    nil
  end
end
