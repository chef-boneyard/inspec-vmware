class VSphere
  def initialize
    # TODO: this does not belong here and should be an InSpec target information
    # can I extend this from InSpec
    @conn_opts = {
      host: '192.168.10.139',
      user: 'root',
      password: 'vmwarevmware',
      insecure: true,
    }
    require 'rbvmomi'
  end

  def connection
    return @conn if defined?(@conn)
    @conn = RbVmomi::VIM.connect @conn_opts
  end
end
