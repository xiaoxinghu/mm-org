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

      def org_options
        org_controller.options
      end

      def render(opts={}, locs={}, &block)
        unless opts.has_key?(:layout)
          opts[:layout] = org_options.layout if opts[:layout].nil?
          # Convert to a string unless it's a boolean
          opts[:layout] = opts[:layout].to_s if opts[:layout].is_a? Symbol
        end

        content = super(opts, locs, &block)
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
        data['title']
      end

      def published?
        data["published"]
      end

      def body
        render layout: false
      end

      def date
        return @_date if @_date

        frontmatter_date = data['date']

        # First get the date from frontmatter
        if frontmatter_date.is_a? Time
          @_date = frontmatter_date.in_time_zone
        else
          @_date = Time.zone.parse(frontmatter_date.to_s)
        end

        @_date
      end

    end
  end
end
