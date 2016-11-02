require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareVmDevice < Inspec.resource(1)
  name 'vm_device'

  desc "
    This resources reads all vm advanced configuration options.
  "

  example "
    describe vm_device({datacenter: 'ha-datacenter', vm: 'vm001', device: 'Floppy'}) do
      its('connected') { should eq 'false' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts;
  end

  # Expose all parameters
  def method_missing(name)
    return connected[name.to_s]
  end

  def exists?
    #return false
    vm = get_vm(@opts[:datacenter], @opts[:vm])
    vm.config.hardware.device.each do |item|
      if item.deviceInfo.label.include?(@opts[:device])
        return true
      end
    end
    return false
  end

  def connected
    return @params if defined?(@params)
    vm = get_vm(@opts[:datacenter], @opts[:vm])
    if vm.nil?
      @params = {}
    else
      vm.config.hardware.device.each do |item|
        if item.deviceInfo.label.include?(@opts[:device])
          return item.props[:connectable].connected
        end
      end
      false
    end
  end

  def get_vm(datacenter_name, vm_name)
    begin
      # TODO: this should something like `inspec.vsphere.connection`
      vim = VSphere.new.connection
      dc = vim.serviceInstance.find_datacenter(datacenter_name)
      vm = dc.find_vm(vm_name)
      vm
    rescue Exception => e
      # TODO: proper logging
      puts e.message
      puts e.backtrace.inspect
      nil
    end
  end
end
