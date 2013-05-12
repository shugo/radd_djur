require "immutable"

module Haensel
  class Grammar
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

    class Parser
      include Immutable

      def initialize(&block)
        @block = block
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
              p2.parse(result.remainder)
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
              p2.parse(d)
            end
          }
        }
      end
    end

    module Parsers
      include Immutable

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

    include Parsers

    def initialize(start_symbol, &block)
      @parsers = {}
      @start_symbol = start_symbol
      instance_exec(&block) if block
    end

    def parse(str)
      result = Derivs.new(self, str).send(@start_symbol).force
      if !result.succeeded?
        raise ParseError, "parse error"
      end
      result.value
    end

    def define(sym, parser = yield)
      @parsers[sym] = parser
    end

    def parser(sym)
      @parsers[sym]
    end

    def method_missing(mid, *args)
      Parser.new(&mid)
    end
  end
end
