# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/office_macro_run_count'

describe :office_macro_run_count, type: :fact do
  subject(:fact) { Facter.fact(:office_macro_run_count) }

  before :each do
    # perform any action that should be run before every test
    Facter.clear
  end

  it 'returns a value' do
    expect(fact.value).is_a? Integer
  end
end
