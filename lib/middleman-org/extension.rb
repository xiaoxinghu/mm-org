require 'middleman-org/org_data'
require 'middleman-org/org_article'
require 'middleman-org/helpers'

module Middleman
  class OrgExtension < ::Middleman::Extension
    self.supports_multiple_instances = true

    option :name, nil, 'Unique ID for telling multiple orgs apart'
    option :layout, 'layout', 'article specific layout'
    option :root, 'org', 'source folder for org files'
    option :prefix, nil, 'prefix on destination and root path'

    option :emacs, 'emacs', 'emacs executable'
    option :load, nil, 'load elisp file'

    attr_reader :data
    attr_reader :name

    self.defined_helpers = [Middleman::Org::Helpers]
    def initialize(app, options_hash = {}, &block)
      # Call super to build options from the options_hash
      super

      # Require libraries only when activated
      require 'emacs-ruby'
      require 'org-ruby'
      require 'middleman-org/org_data'
      ::Tilt.prefer(Tilt::OrgTemplate, 'org')

      @name = options.name.to_sym if options.name
      # options.root = File.join(options.prefix, options.root) if options.prefix

      app.after_configuration do
        template_extensions org: :html
        if config[:org_engine] == :emacs_ruby
          ::Tilt.prefer(Tilt::EmacsRuby::OrgTemplate, 'org')
        end
      end

      # set up your extension
      # puts options.my_option
    end

    def after_configuration
      @name ||= :"org#{::Middleman::Org.instances.keys.length}"
      ::Middleman::Org.instances[@name] = self

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
