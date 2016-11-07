require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareHostAdvancedSetting < Inspec.resource(1)
  name 'host_advancedsetting'

  desc "
    This resources reads all host advanced configuration options.
  "

  example "
    describe host_advancedsetting({datacenter: 'ha-datacenter', host: '1'}) do
      its('softPowerOff') { should eq 'false' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  # Expose all parameters
  def method_missing(name) # rubocop:disable Style/MethodMissing
    advancedsetting[name.to_s]
  end

  private

  def advancedsetting
    return @params if defined?(@params)
    host = get_host(@opts[:datacenter], @opts[:host])
    if host.nil?
      @params = {}
    else
      # convert to key value pairs
      @params = {}
      options = host.configManager.advancedOption.setting
      options.each { |item|
        @params[item.key] = item.value
      }
      @params
    end
  end

  def get_host(dc_name, host_name)
    # TODO: this should something like `inspec.vsphere.connection`
    vim = VSphere.new.connection
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
