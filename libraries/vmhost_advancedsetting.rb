require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareHostAdvancedSetting < Inspec.resource(1)
  name 'vmhost_advancedsetting'

  desc "
    This resource reads all host advanced configuration options.
  "

  example "
    describe host_advancedsetting(datacenter: 'ha-datacenter', host: 'localhost') do
      its('softPowerOff') { should eq 'false' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  def method_missing(name) # rubocop:disable Style/MethodMissing
    advancedsetting[name.to_s]
  end

  private

  # returns all advanced settings
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
