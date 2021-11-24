# frozen_string_literal: true

require 'spec_helper'

describe 'acsc_e8_office_hardening::disable_flash' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
