# InSpec vSphere Resource Pack

This resource pack provides resources for vSphere/ESX. It will ship with the required resources to write your own compliance rules.

```
├── README.md - this readme
├── controls - contains no controls
└── libraries - contains vsphere resources
```

## Get started

To run the profile, use inspec with an environment variable:

`INSPEC_ESX_CONN=vsphere://username:password@host inspec exec inspec-vsphere`


## Use the resources

Since this is a resource pack, it only defines InSpec resources. There are no controls included in this resource pack. To use the resources in your tests do the following.

### Adapt the `inspec.yml`

```
name: my-profile
title: My own VMware profile
version: 0.1.0
depends:
  - name: vmware
    url: https://github.com/chris-rock/inspec-vsphere/archive/master.tar.gz
```

### Add controls

Since your profile depends on the resource pack, you can use those resources in your own profile:

```
control "vmware-1" do
  impact 0.7
  title 'Checks that soft power off is diabled'
  describe vmware_vm_advancedsetting({datacenter: 'ha-datacenter', vm: 'testvm'}) do
    its('softPowerOff') { should cmp 'false' }
  end
end
```

### Available Resources

 * `vmhost_acceptance` - This resource reads the switch configuration of a hostsystem
 * `vmhost_advancedsetting` - This resource reads all host advanced configuration options.
 * `vmhost_buildnumber` - This resource reads the actual build number of a hostsystem.
 * `vmhost_lockdown` - This resource reads the lockdown mode of a hostsystem.
 * `vmhost_ntp` - This resource reads the ntp configuration of a hostsystem.
 * `vmhost_service` - This resource reads service information of the host system.
 * `vmhost_vswitch` - This resource reads the vswitch configuration of a hostsystem
 * `vm_advancedsetting` - This resource reads all vm advanced configuration options.
 * `vm_device` - This resource reads all vm device configuration options.
 * `virtual_portgroup` - This resource reads the portgroups of a hostsystem.

### Roadmap

 * `vm_harddisk`
 * `vmhost_coredump`
 * `vmhost_account`
 * `vmhost_authentication`
 * `vmhost_webserver`
 * `vmhost_firewall`
 * `vmhost_module`
 * `vmhost_vib`
 * `vmhost_iscsi`

## Pre-Requirements

```
# inspec
gem install inspec
# gem for VMware vSphere API
gem install rbvmomi
```

# VSphere API Explorer

You can inspect the VSphere API via `/mob` on your ESX server.
