require 'middleman-core'
require 'middleman-org/version'

::Middleman::Extensions.register(:org) do
  require 'middleman-org/extension'
  ::Middleman::OrgExtension
end
