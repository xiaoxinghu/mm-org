require 'active_support/time_with_zone'
require 'active_support/core_ext/time/acts_like'
require 'active_support/core_ext/time/calculations'
require 'nokogiri'

module Middleman
  module Org

    module OrgArticle
      def self.extended(base)
        base.class.send(:attr_accessor, :org_controller)
      end

      def org_data
        org_controller.data
      end

      def org_options
        org_controller.options
      end

      IN_BUFFER_SETTING_REGEXP = /^#\+(\w+):\s*(.*)$/

      def in_buffer_setting
        return @_in_buffer_setting if @_in_buffer_setting

        @_in_buffer_setting = {}
        File.open(source_file, 'r') do |f|
          f.each_line do |line|
            if line =~ IN_BUFFER_SETTING_REGEXP
              @_in_buffer_setting[$1] = $2
            end
          end
        end
        @_in_buffer_setting
      end

      def render(opts={}, locs={}, &block)
        unless opts.has_key?(:layout)
          opts[:layout] = org_options.layout if opts[:layout].nil?
          # Convert to a string unless it's a boolean
          opts[:layout] = opts[:layout].to_s if opts[:layout].is_a? Symbol
        end

        opts[:emacs] = org_options.emacs
        opts[:load] = org_options.load

        content = super(opts, locs, &block)
        # testing
        # content = export source_file
        fix_links(content)
      end

      def fix_links(content)
        html = ::Nokogiri::HTML(content)
        html.xpath("//@src | //@href | //@poster").each do |attribute|
          attribute.value = attribute.value.gsub(/^(.+)\.org$/, '\1.html')
        end
        html.to_s
      end

      def title
        in_buffer_setting['TITLE'] || File.basename(source_file, '.*')
      end

      def keywords
        article_keywords = in_buffer_setting['KEYWORDS']
        return [] unless article_keywords

        if article_keywords.is_a? String
          article_keywords.split(' ').map(&:strip)
        else
          Array(article_keywords).map(&:to_s)
        end
      end

      def description
        in_buffer_setting['DESCRIPTION'] || 'no description'
      end

      def category
        in_buffer_setting['CATEGORY'] || ''
      end

      def published?
        in_buffer_setting['DATE'] || false
      end

      def body
        render layout: false
      end

      def date
        return @_date if @_date

        return nil unless in_buffer_setting['DATE']
        @_date = Date.parse in_buffer_setting['DATE']

        # frontmatter_date = data['date']

        # # First get the date from frontmatter
        # if frontmatter_date.is_a? Time
        #   @_date = frontmatter_date.in_time_zone
        # else
        #   @_date = Time.zone.parse(frontmatter_date.to_s)
        # end

        @_date
      end

      def slug
      end

    end
  end
end
