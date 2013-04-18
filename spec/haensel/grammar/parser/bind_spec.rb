require "spec_helper"

describe Grammar::Parser do
  describe "#bind" do
    before do
      @alpha = Grammar::Parser.new { |d|
        if d.char.succeeded? && /[a-zA-Z]/.match(d.char.value)
          Grammar::Parsed.new(d.char.value, d.char.remainder)
        else
          Grammar::NO_PARSE
        end
      }
      @number = Grammar::Parser.new { |d|
        if d.char.succeeded? && /\d/.match(d.char.value)
          Grammar::Parsed.new(d.char.value, d.char.remainder)
        else
          Grammar::NO_PARSE
        end
      }
    end

    it "returns a Parser which applies two parsers sequentially" do
      alnum = @alpha.bind { |x|
        @number.bind { |y|
          ret x + y
        }
      }
      d1 = Grammar::Derivs.new(nil, "a1")
      r1 = alnum.parse(d1)
      expect(r1.succeeded?).to eq true
      expect(r1.value).to eq "a1"
      d2 = Grammar::Derivs.new(nil, "a")
      r2 = alnum.parse(d2)
      expect(r2.succeeded?).to eq false
      d3 = Grammar::Derivs.new(nil, "1")
      r3 = alnum.parse(d3)
      expect(r3.succeeded?).to eq false
      d4 = Grammar::Derivs.new(nil, "")
      r4 = alnum.parse(d4)
      expect(r4.succeeded?).to eq false
    end

    it "can be nested more than 2 levels deep" do
      alalnum = @alpha.bind { |x|
        @alpha.bind { |y|
          @number.bind { |z|
            ret x + y + z
          }
        }
      }
      d1 = Grammar::Derivs.new(nil, "ab1")
      r1 = alalnum.parse(d1)
      expect(r1.succeeded?).to eq true
      expect(r1.value).to eq "ab1"
      d2 = Grammar::Derivs.new(nil, "a1")
      r2 = alalnum.parse(d2)
      expect(r2.succeeded?).to eq false
    end
  end
end
