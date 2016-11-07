require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareHostLockdown < Inspec.resource(1)
  name 'vmhost_lockdown'

  desc "
    This resource reads the lockdown mode of a hostsystem.
  "

  example "
    describe host_lockdown({datacenter: 'ha-datacenter', host: 'localhost') do
      it { should be_enabled }
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

  def enabled?
    host = get_host(@opts[:datacenter], @opts[:host])
    host.config.lockdownMode.include?('Enabled')
  end

  def disabled?
    !enabled?
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
