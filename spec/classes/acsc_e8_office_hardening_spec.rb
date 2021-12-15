# frozen_string_literal: true

require 'spec_helper'

describe 'acsc_e8_office_hardening' do
  localsids = { 'local_sids' => [ 'Debian', 'ipaddress' ], 'office_macro_last_run' => 'first_run' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts.merge!(localsids) }
      let(:params) { { 'trusted_locations' => { 'location1' => { 'path' => 'c:\\temp' } }, 'macro_setting' => 'macros_from_trused_locations' } }

      it { is_expected.to compile }
    end
  end
end
