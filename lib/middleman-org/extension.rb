require 'middleman-org/org_data'
require 'middleman-org/org_article'
require 'middleman-org/helpers'

module Middleman
  class OrgExtension < ::Middleman::Extension
    option :layout, 'layout', 'article specific layout'
    option :prefix, nil, 'prefix on destination path'
    option :resources, nil, 'folder name for resources'

    attr_reader :data

    self.defined_helpers = [ Middleman::Org::Helpers ]
    def initialize(app, options_hash={}, &block)
      # Call super to build options from the options_hash
      super

      # Require libraries only when activated
      require 'org-ruby'
      require 'middleman-org/org_data'

      if options.prefix
        options.prefix = "/#{options.prefix}" unless options.prefix.start_with? '/'
      end

      app.after_configuration do
        template_extensions org: :html
      end

      # set up your extension
      # puts options.my_option
    end

    def after_configuration
      ::Middleman::Org.controller = self

      # Make sure ActiveSupport's TimeZone stuff has something to work with,
      # allowing people to set their desired time zone via Time.zone or
      # set :time_zone
      Time.zone = app.config[:time_zone] if app.config[:time_zone]
      time_zone = Time.zone || 'UTC'
      zone_default = Time.find_zone!(time_zone)
      unless zone_default
        raise 'Value assigned to time_zone not recognized.'
      end
      Time.zone_default = zone_default

      @data = Org::OrgData.new(@app, self, options)
      @app.sitemap.register_resource_list_manipulator(:"org_articles", @data, false)
    end

  end
end
