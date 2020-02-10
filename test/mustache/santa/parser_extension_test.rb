# frozen_string_literal: true

require 'test_helper'

class Mustache
  module Santa
    class ParserExtensionTest < Minitest::Test
      def setup
        @parser = Mustache::Parser.new
      end

      def test_tag
        actual = @parser.compile('{{foo(bar=baz dot="bar.baz").foobar}}')
        expected = [:multi, [:mustache, :etag, [:mustache, :fetch, ['foo(bar=baz dot="bar.baz")', 'foobar']], [1, 34]]]
        assert_equal actual, expected
      end

      def test_section
        actual = @parser.compile \
          '{{#foo(bar=baz dot="bar.baz").foo(bar=baz)}}content{{/foo.foo}}'
        expected = [:multi, [:mustache, :section, [:mustache, :fetch, ['foo(bar=baz dot="bar.baz")', 'foo(bar=baz)']], [1, 41], [:multi, [:static, 'content']], 'content', ['{{', '}}']]]
        assert_equal actual, expected
      end

      def test_inverted_section
        actual = @parser.compile \
          '{{^foo(bar=baz dot="bar.baz").foo(bar=baz)}}content{{/foo.foo}}'
        expected = [:multi, [:mustache, :inverted_section, [:mustache, :fetch, ['foo(bar=baz dot="bar.baz")', 'foo(bar=baz)']], [1, 41], [:multi, [:static, 'content']], 'content', ['{{', '}}']]]
        assert_equal actual, expected
      end
    end
  end
end
