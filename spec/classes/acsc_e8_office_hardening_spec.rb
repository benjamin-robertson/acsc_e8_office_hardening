# frozen_string_literal: true

require 'spec_helper'

describe 'acsc_e8_office_hardening' do
  localsids = { 'office_macro_local_sids' => [ 'Debian', 'ipaddress' ], 'office_macro_last_run' => 'macros_from_trusted_locations', 'office_macro_uptime' => 90 }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge!(localsids) }
      let(:params) { { 'trusted_locations' => { 'location1' => { 'path' => 'c:\\temp' } }, 'macro_setting' => 'clear_macro_settings' } }

      it { is_expected.to compile }
    end
  end
end
