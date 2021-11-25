# frozen_string_literal: true

require 'spec_helper'
require 'facter'
require 'facter/local_sids'

describe :local_sids, type: :fact do
  subject(:fact) { Facter.fact(:local_sids) }

  before :each do
    # perform any action that should be run before every test
    Facter.clear
  end

end
