require 'spec_helper'

describe 'puppet_agent' do
  package_version = '1.10.100'
  pe_version = '2000.0.0'

  let(:params) { { package_version: package_version } }

  before(:each) do
    # Need to mock the PE functions
    Puppet::Parser::Functions.newfunction(:pe_build_version, type: :rvalue) do |_args|
      pe_version
    end

    Puppet::Parser::Functions.newfunction(:pe_compiling_server_aio_build, type: :rvalue) do |_args|
      package_version
    end
  end

  [['x64', 'x86_64'], ['x86', 'i386']].each do |arch, tag|
    describe "supported Windows #{arch} environment" do
      let(:appdata) { 'C:\ProgramData' }
      let(:facts) do
        {
          is_pe: true,
          osfamily: 'windows',
          operatingsystem: 'windows',
          architecture: arch,
          servername: 'master.example.vm',
          clientcert: 'foo.example.vm',
          puppet_confdir: "#{appdata}\\Puppetlabs\\puppet\\etc",
          puppet_agent_appdata: appdata,
          env_temp_variable: 'C:/tmp',
          puppet_agent_pid: 42,
          aio_agent_version: '1.0.0',
        }
      end

      it { is_expected.to contain_file("#{appdata}\\Puppetlabs") }
      it { is_expected.to contain_file("#{appdata}\\Puppetlabs\\packages") }
      it {
        is_expected.to contain_file("#{appdata}\\Puppetlabs\\packages\\puppet-agent-#{arch}.msi").with(
          'source' => "puppet:///pe_packages/#{pe_version}/windows-#{tag}/puppet-agent-#{arch}.msi",
        )
      }
    end
  end

  [['x64', 'x86_64'], ['x86', 'i386']].each do |arch, tag|
    describe "supported Windows #{arch} environment with auto" do
      server_version = '1.10.100'
      let(:params)  { { package_version: 'auto' } }
      let(:appdata) { 'C:\ProgramData' }
      let(:facts) do
        {
          is_pe: true,
          osfamily: 'windows',
          operatingsystem: 'windows',
          architecture: arch,
          servername: 'master.example.vm',
          clientcert: 'foo.example.vm',
          puppet_confdir: "#{appdata}\\Puppetlabs\\puppet\\etc",
          puppet_agent_appdata: appdata,
          env_temp_variable: 'C:/tmp',
          puppet_agent_pid: 42,
          aio_agent_version: '1.0.0',
          serverversion: server_version
        }
      end

      it { is_expected.to contain_file("#{appdata}\\Puppetlabs") }
      it { is_expected.to contain_file("#{appdata}\\Puppetlabs\\packages") }
      it {
        is_expected.to contain_file("#{appdata}\\Puppetlabs\\packages\\puppet-agent-#{arch}.msi").with(
          'source' => "puppet:///pe_packages/#{pe_version}/windows-#{tag}/puppet-agent-#{arch}.msi",
        )
      }
    end
  end

  describe 'supported Windows with fips mode enabled' do
    server_version = '1.10.100'
    let(:arch) { 'x64' }
    let(:tag) { 'x86_64' }
    let(:params)  { { package_version: 'auto' } }
    let(:appdata) { 'C:\ProgramData' }
    let(:facts) do
      {
        is_pe: true,
        osfamily: 'windows',
        operatingsystem: 'windows',
        architecture: arch,
        servername: 'master.example.vm',
        clientcert: 'foo.example.vm',
        puppet_confdir: "#{appdata}\\Puppetlabs\\puppet\\etc",
        puppet_agent_appdata: appdata,
        env_temp_variable: 'C:/tmp',
        puppet_agent_pid: 42,
        aio_agent_version: '1.0.0',
        serverversion: server_version,
        fips_enabled: true
      }
    end

    it { is_expected.to contain_file("#{appdata}\\Puppetlabs") }
    it { is_expected.to contain_file("#{appdata}\\Puppetlabs\\packages") }
    it do
      is_expected.to contain_file("#{appdata}\\Puppetlabs\\packages\\puppet-agent-#{arch}.msi").with(
        'source' => "puppet:///pe_packages/#{pe_version}/windowsfips-#{tag}/puppet-agent-#{arch}.msi",
      )
    end
  end
end
