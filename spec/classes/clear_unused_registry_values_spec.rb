# frozen_string_literal: true

require 'spec_helper'

describe 'acsc_e8_office_hardening::clear_unused_registry_values' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { { 'system_setting' => 'all_macros_disabled', 'configured_setting' => 'signed_macros_only' } }

      it { is_expected.to compile }
    end
  end
end
