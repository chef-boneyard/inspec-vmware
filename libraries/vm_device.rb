require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareVmDevice < Inspec.resource(1)
  name 'vm_device'

  desc "
    This resource reads all vm device configuration options.
  "

  example "
    describe vm_device({datacenter: 'ha-datacenter', vm: 'vm001', device: 'Floppy'}) do
      its('connected') { should eq 'false' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  # Expose all parameters
  def method_missing(name) # rubocop:disable Style/MethodMissing
    connected[name.to_s]
  end

  def exists?
    vm = get_vm(@opts[:datacenter], @opts[:vm])
    return false if vm.nil?
    vm.config.hardware.device.each do |item|
      if item.deviceInfo.label.include?(@opts[:device])
        return true
      end
    end
    false
  end

  def connected
    return @params if defined?(@params)
    vm = get_vm(@opts[:datacenter], @opts[:vm])
    return @params = {} if vm.nil?
    vm.config.hardware.device.each do |item|
      if item.deviceInfo.label.include?(@opts[:device])
        return item.props[:connectable].connected
      end
    end
    false
  end

  def get_vm(datacenter_name, vm_name)
    # TODO: this should something like `inspec.vsphere.connection`
    conn = ESXConnection.new.connection
    return if conn.nil?
    dc = conn.serviceInstance.find_datacenter(datacenter_name)
    vm = dc.find_vm(vm_name)
    vm
  end
end
