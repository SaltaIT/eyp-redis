require 'spec_helper_acceptance'
require_relative './version.rb'

describe 'redis class' do

  context 'basic setup' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOF

      class { 'redis': }

      redis::instance { '6666':
      }

      EOF

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe port(6666) do
      it { is_expected.to be_listening }
    end

    it "puppet --version" do
      expect(shell("puppet --version").exit_code).to be_zero
    end

    describe file("/etc/redis/redis-6666.conf") do
      it { should be_file }
      its(:content) { should match '# puppet managed file' }
    end

  end
end
