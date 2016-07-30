# TODO: move to example directoy
control "vmware-1" do
  impact 0.7
  title 'Checks that soft power off is diabled'
  describe vmware_vm_advancedsetting({datacenter: 'ha-datacenter', vm: 'testvm'}) do
    its('softPowerOff') { should eq 'false' }
  end
end
