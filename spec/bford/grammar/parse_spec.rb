require "spec_helper"

describe Grammar do
  describe "#parse" do
    before do
      @arith_grammar = Grammar.new(:additive) {
        define :additive,
          multitive.bind { |x|
            char(?+).bind {
              additive.bind { |y|
                ret x + y
              }
            }
          } /
          multitive

        define :multitive,
          primary.bind { |x|
            char(?*).bind {
              multitive.bind { |y|
                ret x * y
              }
            }
          } /
          primary

        define :primary,
          char(?().bind {
            additive.bind { |x|
              char(?)).bind {
                ret x
              }
            }
          } /
          digits

        define :digits,
          digit.bind { |x|
            digits.bind { |y|
              ret (x + y.to_s).to_i
            }
          } /
          digit.bind { |x|
            ret x.to_i
          }

        define :digit,
          any_char.bind { |c|
            if /\d/.match(c)
              ret c
            else
              fail
            end
          }
      }
    end

    it "returns the result when parsing succeeded" do
      expect(@arith_grammar.parse("1+2")).to eq 3
    end

    it "raises a ParseError when parsing failed" do
      expect {
        @arith_grammar.parse("(1+2")
      }.to raise_error Grammar::ParseError
    end
  end
end
