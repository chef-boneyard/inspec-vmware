require 'esx_conn'

# Custom resource based on the InSpec resource DSL
class VmWareConfig < Inspec.resource(1)
  name 'vm_advancedsetting'

  desc "
    This resource reads all vm advanced configuration options.
  "

  example "
    describe vmware_vm_advancedsetting(datacenter: 'ha-datacenter', vm: 'vm001') do
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

  def to_s
    "vmware_vm_advancedsetting DC: #{@opts[:datacenter]} VM: #{@opts[:vm]}"
  end

  private

  # returns all advanced settings
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
    # TODO: this should something like `inspec.vsphere.connection`
    vim = ESXConnection.new.connection
    dc = vim.serviceInstance.find_datacenter(datacenter_name)
    vm = dc.find_vm(vm_name)
    vm
  end
end
