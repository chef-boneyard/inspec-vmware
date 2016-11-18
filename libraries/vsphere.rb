require_relative 'esx_conn'

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

  def root_folder
    return @root_folder if defined?(@root_folder)
    conn = ESXConnection.new.connection
    return if conn.nil?
    @root_folder = conn.serviceInstance.content.rootFolder
  end

  def datacenters
    return @dcs if defined?(@dcs)
    return [] if root_folder.nil?
    @dcs = root_folder.childEntity.grep(RbVmomi::VIM::Datacenter).map { |dc| ESXDatacenter.new(dc) }
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
