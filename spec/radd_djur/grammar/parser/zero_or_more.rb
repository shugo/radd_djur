require "spec_helper"

describe Grammar::Parser do
  describe "#zero_or_more" do
    it "returns a Parser which represents zero or more consecutive repetitions of self" do
      opt_spaces = any_char.bind { |c|
        if /\s/.match(c)
          ret c
        else
          fail
        end
      }.zero_or_more
      d1 = Grammar::Derivs.new(nil, "")
      r1 = opt_spaces.parse(d1).force
      expect(r1.succeeded?).to eq true
      expect(r1.value).to eq List[]
      d2 = Grammar::Derivs.new(nil, " ")
      r2 = opt_spaces.parse(d2).force
      expect(r2.succeeded?).to eq true
      expect(r2.value).to eq List[" "]
      d3 = Grammar::Derivs.new(nil, " \t ")
      r3 = opt_spaces.parse(d3).force
      expect(r3.succeeded?).to eq true
      expect(r3.value).to eq List[" ", "\t", " "]
    end
  end
end
