location = File.expand_path('/dev/null')

@default_module_facts = {
  aio_agent_version: '5.5.10',
  puppetversion: '5.5.10',
  lsbdistrelease: nil,
  is_pe: false,
  platform_tag: nil,
  operatingsystem: nil,
  operatingsystemmajrelease: nil,
  kernelmajversion: nil,
  macosx_productname: nil,
  maxosx_productversion_major: nil,
  rubyplatform: nil,
  puppet_master_server: nil,
  puppet_client_datadir: nil,
  path: nil,
  puppet_agent_appdata: nil,
  system32: nil,
  fips_enabled: false,

  puppet_ssldir: "#{location}/ssl",
  puppet_config: "#{location}/puppet.conf",
  puppet_sslpaths: {
    'privatedir' => {
      'path' => "#{location}/ssl/private",
      'path_exists' => true,
    },
    'privatekeydir' => {
      'path' => "#{location}/ssl/private_keys",
      'path_exists' => true,
    },
    'publickeydir' => {
      'path' => "#{location}/ssl/public_keys",
      'path_exists' => true,
    },
    'certdir' => {
      'path' => "#{location}/ssl/certs",
      'path_exists' => true,
    },
    'requestdir' => {
      'path' => "#{location}/ssl/certificate_requests",
      'path_exists' => true,
    },
    'hostcrl' => {
      'path' => "#{location}/ssl/crl.pem",
      'path_exists' => true,
    },
  },
}

RSpec.configure do |c|
  c.before :each do
    Puppet::Parser::Functions.newfunction(:pe_build_version, type: :rvalue, doc: '') do |_args|
      '2018.1.0'
    end
  end
end
