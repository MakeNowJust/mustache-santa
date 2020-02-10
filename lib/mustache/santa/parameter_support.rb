# frozen_string_literal: true

# :nodoc:
class Mustache
  module Santa
    # ParameterSupport is mix-in module to support parameter
    # to Mustache context object.
    module ParameterSupport
      def self.parse_name(name)
        m = name.match(ParserExtension::CONTENT_PART)
        return unless m

        name = m[:name]
        return unless (params = m[:params])

        params = params[1..-2] if params[0] == '(' && params[-1] == ')'

        params = params
                 .scan(ParserExtension::CONTENT_PARAM)
                 .map { |key, *values| [key.intern, values.find(&:itself)] }
                 .to_h

        [name, params]
      end

      def method_missing(name, *args, **kwargs, &block)
        method_name, params = ParameterSupport.parse_name(name)
        return super unless method_name

        send(method_name, **params)
      end

      def respond_to_missing?(name, _include_private)
        m = name.match(/\A\s*(?<name>\w+[?!]?)/)
        return super unless m

        methods.include?(m[:name].intern)
      end
    end
  end
end
