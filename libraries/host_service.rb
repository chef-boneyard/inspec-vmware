require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareHostService < Inspec.resource(1)
  name 'host_service'

  desc "
    This resources reads the actual build number of a hostsystem.
  "

  example "
    describe host_service({datacenter: 'ha-datacenter', host: 'localhost', service: 'TSM'}) do
      it { should exist }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts;
  end

  # Expose all parameters
  def method_missing(name)
    return [name.to_s]
  end

  def exists?
    host = get_host(@opts[:datacenter], @opts[:host])
    options = host.configManager.serviceSystem.serviceInfo.service
    services = Array.new
    options.each do |name|
      services.push(name.key)
    end
    services.include?(@opts[:service])
  end

  def enabled?
    host = get_host(@opts[:datacenter], @opts[:host])
    options = host.configManager.serviceSystem.serviceInfo.service
    services = Array.new
    options.each do |name|
      return name.key == @opts[:service] && name.policy == "on"
    end
  end

  def disabled?
    !enabled?
  end

  def get_host(dc_name, host_name)
    begin
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
    rescue Exception => e
      # TODO: proper logging
      puts e.message
      puts e.backtrace.inspect
      nil
    end
  end
end
