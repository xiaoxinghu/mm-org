module Middleman
  class OrgExtension < ::Middleman::Extension

    option :emacs, 'emacs', 'emacs executable'
    option :load, nil, 'load elisp file'
    option :defaults, {}, 'default values if the keys do not exsist'
    option :alias, {}, 'alias'

    # self.defined_helpers = [Middleman::Org::Helpers]
    def initialize(app, options_hash = {}, &block)
      # Call super to build options from the options_hash
      super

      # Require libraries only when activated
      require 'org-ruby'
      ::Tilt.prefer(Tilt::OrgTemplate, 'org')

      app.after_configuration do
        template_extensions org: :html
        if config[:org_engine] == :emacs_ruby
          require 'emacs-ruby'
          ::Tilt.prefer(Tilt::EmacsRuby::OrgTemplate, 'org')
        end
      end
    end

    def after_configuration
      ::Middleman::Sitemap::Resource.send :include, OrgInstanceMethods
    end

    module OrgInstanceMethods
      def in_buffer_setting
        @in_buffer_setting ||= extract_ibs source_file
      end

      def front_matter
        # this code is from middleman-core
        @enhanced_data ||= ::Middleman::Util.recursively_enhance(raw_data).freeze
      end

      def data
        front_matter.merge(in_buffer_setting)
      end

      private

      IN_BUFFER_SETTING_REGEXP = /^#\+(\w+):\s*(.*)$/

      def extract_ibs(path)
        ibs = {}
        File.open(path, 'r') do |f|
          f.each_line do |line|
            if line =~ IN_BUFFER_SETTING_REGEXP
              key = app.extensions[:org].options[:alias][$1.downcase] || $1.downcase
              key = key.to_sym
              ibs[key] = $2
            end
          end
        end
        app.extensions[:org].options[:defaults].each do |k, v|
          ibs[k] = v unless ibs.has_key?(k)
        end
        ibs
      end
    end
  end
end
