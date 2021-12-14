# frozen_string_literal: true

require 'spec_helper'

describe 'acsc_e8_office_hardening' do
  localsids = { 'local_sids' => [ 'Debian', 'ipaddress' ] }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge!(localsids) }
      let(:params) { { 'trusted_locations' => { 'location1' => { 'path' => 'c:\\temp', 'date' => '20/10/2020', 'description' => 'i am a desc' } } } }

      it { is_expected.to compile }
    end
  end
end
