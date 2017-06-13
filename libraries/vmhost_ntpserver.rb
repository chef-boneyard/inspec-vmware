require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareHostNtpServer < Inspec.resource(1)
  name 'vmhost_ntpserver'

  desc "
    This resource reads the ntp configuration of a hostsystem.
  "

  example "
    describe host_ntpserver(datacenter: 'ha-datacenter', host: 'localhost', ntp: '0.europe.pool.ntp.org') do
      it { should exist }
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

  def exists?
    host = get_host(@opts[:datacenter], @opts[:host])
    options = host.config.dateTimeInfo.ntpConfig.server
    options.include?(@opts[:ntp])
  end

  def to_s
    "NTP Server '#{@opts[:ntp]}'"
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
