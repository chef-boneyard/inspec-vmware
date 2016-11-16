require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareVirtualPortgroup < Inspec.resource(1)
  name 'virtual_portgroup'

  desc "
    This resources reads the switch configuration of a hostsystem.
  "

  example "
    describe virtual_portgroup({datacenter: 'ha-datacenter', host: 'localhost', portgroup: 'VM Network'}) do
      its('vlan') { should_not eq 1 }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  # Expose all parameters
  def method_missing(name) # rubocop:disable Style/MethodMissing
    [name.to_s]
  end

  def vlan
    host = get_host(@opts[:datacenter], @opts[:host])
    pgroups = host.config.network.portgroup
    pgroups.each do |group|
      if group.key.include?(@opts[:portgroup])
        return group.spec.vlanId
      end
    end
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
