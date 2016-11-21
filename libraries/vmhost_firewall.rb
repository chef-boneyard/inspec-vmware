require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareHostFirewall < Inspec.resource(1)
  name 'vmhost_firewall'

  desc "
    This resources reads the switch configuration of a hostsystem.
  "

  example "
    describe vmhost_firewall(datacenter: 'ha-datacenter', host: 'localhost', firewall_rule: 'DHCPv6') do
      its('all_ip') { should eq false }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts
  end

  def to_s
    "vmhost_firewall #{@opts[:firewall_rule]}"
  end

  def all_ip
    host = get_host(@opts[:datacenter], @opts[:host])
    host.config.firewall.ruleset.each do |fw|
      if fw.key == @opts[:firewall_rule]
        return fw.allowedHosts.allIp
      end
    end
  end

  def get_host(dc_name, host_name)
    # TODO: this should something like `inspec.vsphere.connection`
    vim = ESXConnection.new.connection
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
