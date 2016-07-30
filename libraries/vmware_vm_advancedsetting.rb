# Custom resource based on the InSpec resource DSL
class VmWareConfig < Inspec.resource(1)
  name 'vmware_vm_advancedsetting'

  desc "
    This resources reads all vm advanced configuration options.
  "

  example "
    describe vmware_vm_advancedsetting({datacenter: 'ha-datacenter', vm: '1'}) do
      its('softPowerOff') { should eq 'false' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    # TODO: this does not belong here and should be an InSpec target information
    # can I extend this from InSpec
    @conn_opts = {
      host: '192.168.10.139',
      user: 'root',
      password: 'vmwarevmware',
      insecure: true,
    }
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
      # path = File.expand_path('../vendor/gems/**/lib', __FILE__)
      # TODO we need to fix this, File.expand_path is not fetching the right directory
      # also we should be able to load it from tar directly
      # TODO: are vendored gems working cross-platform?
      path = '/Users/chartmann/Development/compliance/inspec-vsphere/vendor/gems/**/lib'
      libs = *Dir[path]
      libs.each { |lib|
        $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
      }
      require 'rbvmomi'
      vim = RbVmomi::VIM.connect @conn_opts
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
