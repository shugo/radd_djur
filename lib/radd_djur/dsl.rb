module RaddDjur
  module DSL
    refine Object do
      def bind(&block)
        to_parser.bind(&block)
      end

      def /(p2)
        to_parser / p2
      end

      def to_parser
        raise TypeError, "#{self.class} can't be converted to a Parser"
      end
    end

    refine Symbol do
      def to_parser
        Grammar::Parser.new(&self)
      end
    end

    refine String do
      def to_parser
        Grammar::Parsers.string(self)
      end
    end

    refine Range do
      def to_parser
        Grammar::Parsers.any_char.bind { |c|
          if self.cover?(c)
            Grammar::Parsers.ret(c)
          else
            Grammar::Parsers.fail
          end
        }
      end
    end
  end
end
