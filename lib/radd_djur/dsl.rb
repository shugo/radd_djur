module RaddDjur
  module DSL
    refine Object do
      def bind(&block)
        to_parser.bind(&block)
      end

      def /(p2)
        to_parser / p2
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
            ret c
          else
            fail
          end
        }
      end
    end
  end
end
