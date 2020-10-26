require 'spec_helper'
require "chef/audit/fetcher/chef_server"

describe Chef::Audit::Fetcher::ChefServer do
  let(:node) do
    Chef::Node.new.tap do |n|
      n.default['audit'] = {}
    end
  end
  let(:compliance_url) { 'compliance://admin/ssh-baseline' }

  before :each do
    allow(Chef).to receive(:node).and_return(node)

    Chef::Config[:chef_server_url] = 'http://127.0.0.1:8889/organizations/my_org'
  end

  context 'when target is a string' do
    it 'should resolve a compliance URL' do
      res = Chef::Audit::Fetcher::ChefServer.resolve(compliance_url)

      expected = "http://127.0.0.1:8889/organizations/my_org/owners/admin/compliance/ssh-baseline/tar"
      expect(res.target).to eq(expected)
    end

    it 'should add /compliance URL prefix if needed' do
      node.default['audit']['fetcher'] = 'chef-server'
      res = Chef::Audit::Fetcher::ChefServer.resolve(compliance_url)

      expected = "http://127.0.0.1:8889/compliance/organizations/my_org/owners/admin/compliance/ssh-baseline/tar"
      expect(res.target).to eq(expected)
    end

    it 'includes user in the URL if present'
    it 'returns nil with a non-compliance URL'
  end

  context 'when target is a hash' do
    it 'should resolve a target with a version' do
      res = Chef::Audit::Fetcher::ChefServer.resolve(
        compliance: 'admin/ssh-baseline',
        version: '2.1.0',
      )

      expected = "http://127.0.0.1:8889/organizations/my_org/owners/admin/compliance/ssh-baseline/version/2.1.0/tar"
      expect(res.target).to eq(expected)
    end

    it 'should resolve a target without a version' do
      res = Chef::Audit::Fetcher::ChefServer.resolve(
        compliance: 'admin/ssh-baseline',
      )

      expected = "http://127.0.0.1:8889/organizations/my_org/owners/admin/compliance/ssh-baseline/tar"
      expect(res.target).to eq(expected)
    end
  end
end
