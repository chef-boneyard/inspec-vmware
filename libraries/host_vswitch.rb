require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareHostVswitch < Inspec.resource(1)
  name 'host_vswitch'

  desc "
    This resources reads the switch configuration of a hostsystem.
  "

  example "
    describe host_vswitch({datacenter: 'ha-datacenter', host: 'localhost', vswitch: 'vSwitch0'}) do
      its('forgedTransmits') { should be false }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  # Expose all parameters
  def method_missing(name) # rubocop:disable Style/MethodMissing
    forgedTransmits[name.to_s]
  end

  def forgedTransmits # rubocop:disable Style/MethodName
    host = get_host(@opts[:datacenter], @opts[:host])
    return if host.nil?
    switches = host.config.network.vswitch
    switches.each do |switch|
      if switch.name == @opts[:vswitch]
        return switch.spec.policy.security.forgedTransmits
      end
    end
  end

  def macChanges # rubocop:disable Style/MethodName
    host = get_host(@opts[:datacenter], @opts[:host])
    return if host.nil?
    switches = host.config.network.vswitch
    switches.each do |switch|
      if switch.name == @opts[:vswitch]
        return switch.spec.policy.security.macChanges
      end
    end
  end

  def allowPromiscuous # rubocop:disable Style/MethodName
    host = get_host(@opts[:datacenter], @opts[:host])
    return if host.nil?
    switches = host.config.network.vswitch
    switches.each do |switch|
      if switch.name == @opts[:vswitch]
        return switch.spec.policy.security.allowPromiscuous
      end
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
