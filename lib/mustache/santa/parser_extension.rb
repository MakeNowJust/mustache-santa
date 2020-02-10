# frozen_string_literal: true

# :nodoc:
class Mustache
  module Santa
    # ParseExtension is extension module for Mustache::Parser.
    module ParserExtension
      PARAM_CONTENT = [nil, '#', '^'].freeze

      CONTENT_PARAM = /
        (?<key>\w+)=(?:"(?<value>(?~"))"|'(?<value>(?~'))'|(?<value>\w*))
      /x.freeze
      CONTENT_PARAMS = /
        (?<params>#{CONTENT_PARAM}(?:\s+#{CONTENT_PARAM})*)?
      /x.freeze
      CONTENT_PART = /
        \s*(?<name>\w+[!?]?)\s*(?:\(#{CONTENT_PARAMS}\)|#{CONTENT_PARAMS})?
      /x.freeze

      def content_tags(type, current_ctag_regex)
        if PARAM_CONTENT.include?(type)
          content_with_params
        else
          super
        end
      end

      def content_with_params
        return unless (part = content_part_with_params)

        parts = [part]
        while @scanner.scan('.')
          return unless (part = content_part_with_params)

          parts << part
        end

        result = parts.join('.')
        result.define_singleton_method :split, ->(_c) { parts }

        result
      end

      def content_part_with_params
        part = @scanner.scan(CONTENT_PART)
        return unless part

        name = @scanner[:name]
        part.define_singleton_method :name, -> { name }

        part
      end

      def scan_tag_block(_content, fetch, padding, pre_match_position)
        normalized_content = fetch[2].map(&:name).join('.')
        super(normalized_content, fetch, padding, pre_match_position)
      end
      alias :'scan_tag_#' scan_tag_block

      def scan_tag_inverted(_content, fetch, padding, pre_match_position)
        normalized_content = fetch[2].map(&:name).join('.')
        super(normalized_content, fetch, padding, pre_match_position)
      end
      alias :'scan_tag_^' scan_tag_inverted
    end
  end

  Parser.prepend(Santa::ParserExtension) if const_defined?(:Parser)
end
