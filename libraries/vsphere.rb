require 'esx_conn'

class ESXInfo < Inspec.resource(1)
  name 'vsphere'

  desc "
    Allows you to iterate over datacenter and vms easily
  "

  example '
    control "vmware-1" do
      impact 1.0
      title "This control iterates over each vm in all datacenters and ensure `softPowerOff` is set to false"
      vsphere.datacenters.each { |dc|
        dc.vms.each { |vm|
          describe vmware_vm_advancedsetting({datacenter: dc.name, vm: vm.name}) do
            its("softPowerOff") { should cmp false }
          end
        }
      }
    end
  '

  def root
    return @root if defined?(@root)
    conn = ESXConnection.new.connection
    @root = conn.serviceInstance.content.rootFolder
  end

  def datacenters
    return @dcs if defined?(@dcs)
    @dcs = root.childEntity.grep(RbVmomi::VIM::Datacenter).map { |dc| ESXDatacenter.new(dc) }
  end
end

class ESXDatacenter
  def initialize(dc)
    @dc = dc
  end

  def name
    @dc.name
  end

  def vms
    @vms = @dc.vmFolder.childEntity.grep(RbVmomi::VIM::VirtualMachine).map { |vm| ESXVm.new(vm) }
  end

  def obj
    @dc
  end
end

class ESXVm
  def initialize(vm)
    @vm = vm
  end

  def name
    @vm.name
  end

  def obj
    @vm
  end
end
