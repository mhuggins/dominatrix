require 'set'
require 'uri'
require 'dominatrix/version'

module Dominatrix
  class NotFoundError < StandardError; end

  class << self
    def parse(uri, extensions = default_extensions)
      uri = URI.parse(uri) if uri.is_a?(String)
      raise ArgumentError, '`uri` must be a String or URI' unless uri.is_a?(URI)
      raise ArgumentError, '`uri` must include a host' if uri.host.nil?
      raise ArgumentError, '`extensions` must be Enumerable' unless extensions.is_a?(Enumerable)

      domain = extract_domain(uri.host, extensions)
      raise NotFoundError, "no matching domain for \"#{uri}\"" if domain.nil?
      domain
    end

    def default_extensions
      @default_domains ||= begin
        file = File.join(File.dirname(__FILE__), 'extensions.txt')
        File.readlines(file).map(&:strip).delete_if(&:empty?).to_set
      end
    end

    private

    def extract_domain(host, extensions)
      parts = host.split('.')
      last_found_domain = nil

      parts.size.times.each do |n|
        offset = parts.size - n - 1
        lookup = '.' + parts[offset..-1].join('.')

        if extensions.include?(lookup)
          last_found_domain = lookup
        elsif last_found_domain
          last_found_domain = parts[offset] + last_found_domain
          break
        else
          break
        end
      end

      last_found_domain
    end
  end
end
