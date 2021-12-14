# frozen_string_literal: true

Facter.add(:office_macro_last_run) do
  # https://puppet.com/docs/puppet/latest/fact_overview.html
  setcode do
    'hello facter'
  end
end
