# Checks that internal links point to valid pages.

# We use Addressable::URI for compatibility with Jekyll.
require 'addressable/uri'

module JekyllPrepublish
  class InternalLinkValidator
    def describe_validation
      'Checking internal links.'
    end

    # Finds internal links that do not point to an existing page and returns an
    # error message containing the text of each of those links. Returns nil if
    # no bad links were found.
    def validate(_post, document, site)
      site_url_paths = Set.new((site.posts.docs + site.pages).map do |page|
        Addressable::URI::parse(page.url).path
      end)
      bad_links = Hash.new { |h, k| h[k] = [] }

      site_url = site.config["url"]
      site_host = nil
      site_scheme = nil
      if not site_url.nil? and not site_url.empty?
        parsed_site_url = Addressable::URI::parse(site_url)
        site_host = parsed_site_url.host
        site_scheme = parsed_site_url.scheme
      end

      document.search('a').each do |node|
        link_address = node['href']
        parsed_url = Addressable::URI::parse(link_address)
        # Continue if the link points to another site.
        next unless parsed_url.host.nil? or parsed_url.host == site_host
        if not site_scheme.nil? and not parsed_url.scheme.nil? and
            parsed_url.scheme != site_scheme
          bad_links[link_address] << Messages::BAD_SCHEME
        end
        if not site_url_paths.member?(parsed_url.path)
          bad_links[link_address] << Messages::NONEXISTENT
        end
      end

      return nil if bad_links.empty?

      # Look for internal links that don't exist.
      bad_links.map { |link, messages| "#{link} #{messages.join(" and ")}!" }
        .join("\n")
    end

    # Holds messages applying to bad links.
    module Messages
      BAD_SCHEME = "has the wrong scheme"
      NONEXISTENT = "does not exist"
    end

  end
end
