require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareVmAdvancedSettings < Inspec.resource(1)
  name 'vm_advancedsetting'

  desc "
    This resources reads all vm advanced configuration options.
  "

  example "
    describe vm_advancedsetting({datacenter: 'ha-datacenter', vm: '1'}) do
      its('softPowerOff') { should eq 'false' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts;
  end

  # Expose all parameters
  def method_missing(name)
    return advancedsetting[name.to_s]
  end

  private

  def advancedsetting
    return @params if defined?(@params)
    vm = get_vm(@opts[:datacenter], @opts[:vm])
    if vm.nil?
      @params = {}
    else
      # convert to key value pairs
      @params = {}
      vm.config.extraConfig.each { |item|
        @params[item.key] = item.value
      }
      @params
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
