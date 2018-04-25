require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'redis class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'redis': }

      redis::instance { '1111':
        sentinel => true,
      }

      redis::instance { '1112':
        sentinel => true,
      }

      redis::instance { '1113':
      }

      redis::instance { '1114': }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe port(1111) do
      it { is_expected.to be_listening }
    end

    describe port(1112) do
      it { is_expected.to be_listening }
    end

    describe port(1113) do
      it { is_expected.to be_listening }
    end

    describe port(1114) do
      it { is_expected.to be_listening }
    end

    describe file("/etc/redis/redis-1111.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
      its(:content) { should match 'port 1111' }
    end

    describe file("/etc/redis/redis-1112.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
      its(:content) { should match 'port 1112' }
    end

    describe file("/etc/redis/redis-1113.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
      its(:content) { should match 'port 1113' }
    end

    describe file("/etc/redis/redis-1114.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
      its(:content) { should match 'port 1114' }
    end

    describe service("redis-1111") do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    describe service("redis-1112") do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    describe service("redis-1113") do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    describe service("redis-1114") do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

    describe service($sentinel_servicename) do
      it { should be_enabled }
      it { is_expected.to be_running }
    end

  end
end
