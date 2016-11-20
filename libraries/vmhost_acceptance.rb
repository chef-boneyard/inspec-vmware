require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareHostAcceptance < Inspec.resource(1)
  name 'vmhost_acceptance'

  desc "
    This resource reads the switch configuration of a hostsystem.
  "

  example "
    describe host_acceptance(datacenter: 'ha-datacenter', host: 'localhost') do
      its('viblevel') { should eq 'partner' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  def viblevel
    host = get_host(@opts[:datacenter], @opts[:host])
    return if host.nil?
    level = host.configManager.imageConfigManager.HostImageConfigGetAcceptance
    level
  end

  def get_host(dc_name, host_name)
    # TODO: this should something like `inspec.vsphere.connection`
    vim = ESXConnection.new.connection
    dc = vim.serviceInstance.find_datacenter(dc_name)
    hosts = dc.hostFolder.children
    hosts.each do |entity|
      entity.host.each do |host|
        if host.name == host_name && host.class == RbVmomi::VIM::HostSystem
          return host
        end
      end
    end
  end
end
