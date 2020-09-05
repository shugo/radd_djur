require "immutable"
require "radd_djur/dsl"

using RaddDjur::DSL

module RaddDjur
  class Grammar
    INSTANCE_EVAL_USING_AVAILABLE = 
      begin
        instance_eval(using: RaddDjur::DSL) {}
        true
      rescue
        false
      end

    class Result
    end

    class Parsed < Result
      attr_reader :value, :remainder

      def initialize(value, remainder)
        @value = value
        @remainder = remainder
      end

      def succeeded?
        true
      end
    end

    NO_PARSE = Result.new

    def NO_PARSE.succeeded?
      false
    end

    class ParseError < StandardError; end

    class Derivs
      include Immutable

      def initialize(grammar, str)
        @grammar = grammar
        @str = str
        @memo = {}
      end

      def char
        @memo[:char] ||=
          Promise.delay {
            if @str.empty?
              NO_PARSE
            else
              Parsed.new(@str[0], Derivs.new(@grammar, @str[1..-1]))
            end
          }
      end

      def method_missing(mid, *args)
        @memo[mid] ||= @grammar.parser(mid).parse(self)
      end
    end

    module Parsers
      include Immutable

      module_function

      def ret(value)
        Parser.new { |d|
          Promise.eager(Parsed.new(value, d))
        }
      end

      def fail
        Parser.new { |d|
          Promise.eager(NO_PARSE)
        }
      end

      def any_char
        Parser.new(&:char)
      end

      def char(ch)
        any_char.bind { |c|
          if c == ch
            ret c
          else
            fail
          end
        }
      end

      def string(str)
        if str.empty?
          ret ""
        else
          char(str[0]).bind { |c|
            string(str[1..-1]).bind { |s|
              ret c + s
            }
          }
        end
      end
    end

    class Parser
      include Immutable
      include Parsers

      def initialize(&block)
        @block = block
      end

      def to_parser
        self
      end

      def parse(d)
        @block.call(d)
      end

      def bind(&f2)
        p1 = self
        Parser.new { |d|
          Promise.lazy {
            result = p1.parse(d).force
            if result.succeeded?
              p2 = f2.call(result.value)
              p2.to_parser.parse(result.remainder)
            else
              Promise.eager(NO_PARSE)
            end
          }
        }
      end

      def /(p2)
        p1 = self
        Parser.new { |d|
          Promise.lazy {
            result = p1.parse(d).force
            if result.succeeded?
              Promise.eager(result)
            else
              p2.to_parser.parse(d)
            end
          }
        }
      end

      def optional
        self / ret(nil)
      end

      def zero_or_more
        one_or_more / ret(List.empty)
      end

      def one_or_more
        bind { |x|
          zero_or_more.bind { |xs|
            ret xs.cons(x)
          }
        }
      end
    end

    include Parsers

    def initialize(start_symbol, &block)
      @parsers = {}
      @start_symbol = start_symbol
      if block
        if INSTANCE_EVAL_USING_AVAILABLE
          instance_eval(using: RaddDjur::DSL, &block)
        else
          instance_eval(&block)
        end
      end
    end

    def parse(str)
      result = Derivs.new(self, str).send(@start_symbol).force
      if !result.succeeded?
        raise ParseError, "parse error"
      end
      result.value
    end

    def define(sym, parser = nil, &block)
      if block
        block.using(RaddDjur::DSL)
        parser = block.call
      end
      @parsers[sym] = parser.to_parser
    end

    def parser(sym)
      @parsers[sym]
    end

    def method_missing(mid, *args)
      Parser.new(&mid)
    end
  end
end
