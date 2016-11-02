require 'vsphere'

# Custom resource based on the InSpec resource DSL
class VmWareHostAcceptance < Inspec.resource(1)
  name 'host_acceptance'

  desc "
    This resources reads the switch configuration of a hostsystem.
  "

  example "
    describe host_acceptance({datacenter: 'ha-datacenter', host: 'localhost.localdomain'}) do
      its('viblevel') { should eq 'partner' }
    end
  "

  # Load the configuration file on initialization
  def initialize(opts)
    @opts = opts;
  end

  # Expose all parameters
  def method_missing(name)
    viblevel[name.to_sym]
  end

  def viblevel
    host = get_host(@opts[:datacenter], @opts[:host])
    #require pry; binding.pry
    unless host.nil?
      level = host.configManager.imageConfigManager.HostImageConfigGetAcceptance
      level
    end
  end

  def get_host(dc_name, host_name)
    begin
      # TODO: this should something like `inspec.vsphere.connection`
      vim = VSphere.new.connection
      dc = vim.serviceInstance.find_datacenter(dc_name)
      hosts = dc.hostFolder.children
      hosts.each do |entity|
        entity.host.each do |host|
          if host.name == host_name && host.class == RbVmomi::VIM::HostSystem
            return host
          end
        end
      end
    rescue Exception => e
      # TODO: proper logging
      puts e.message
      puts e.backtrace.inspect
      nil
    end
  end
end
