require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareHostBuildnumber < Inspec.resource(1)
  name 'vmhost_buildnumber'

  desc "
    This resource reads the actual build number of a hostsystem.
  "

  example "
    describe host_buildnumber(datacenter: 'ha-datacenter', host: 'localhost') do
      its('build') { should eq '4192238' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  private

  def build
    return @params if defined?(@params)
    host = get_host(@opts[:datacenter], @opts[:host])
    if host.nil?
      @params = {}
    else
      # convert to key value pairs
      @params = {}
      @params['build'] = host.config.product.build
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
