# frozen_string_literal: true

require 'test_helper'

class Mustache
  module Santa
    class ParameterSupportTest < Minitest::Test
      class TestObject
        include Mustache::Santa::ParameterSupport

        def test(name:)
          "Test #{name}"
        end

        def default_param(key: 'value')
          key
        end

        def multiple_params(key1:, key2:)
          "key1=#{key1}&key2=#{key2}"
        end
      end

      def setup
        @test = TestObject.new
      end

      def test_respond_to
        assert_respond_to @test, :"test(name=Mustache)"
        assert_respond_to @test, :"test name=Mustache"
      end

      def test_method_missing
        assert_equal @test.send(:"test(name=Mustache)"), 'Test Mustache'
        assert_equal @test.send(:"test name=Mustache"), 'Test Mustache'
      end

      def test_default_param
        assert_equal @test.default_param, 'value'
        assert_equal @test.send(:"default_param(key='v')"), 'v'
      end

      def test_multiple_params
        assert_equal \
          @test.send(:'multiple_params(key1=value1 key2="value2")'),
          'key1=value1&key2=value2'
      end
    end
  end
end
