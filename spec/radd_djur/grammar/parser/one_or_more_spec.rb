require "spec_helper"

describe Grammar::Parser do
  describe "#one_or_more" do
    it "returns a Parser which represents one or more consecutive repetitions of self" do
      lword = any_char.bind { |c|
        if /[a-z]/.match(c)
          ret c
        else
          fail
        end
      }.one_or_more
      d1 = Grammar::Derivs.new(nil, "")
      r1 = lword.parse(d1).force
      expect(r1.succeeded?).to eq false
      d2 = Grammar::Derivs.new(nil, "a")
      r2 = lword.parse(d2).force
      expect(r2.succeeded?).to eq true
      expect(r2.value).to eq List["a"]
      d3 = Grammar::Derivs.new(nil, "abc")
      r3 = lword.parse(d3).force
      expect(r3.succeeded?).to eq true
      expect(r3.value).to eq List["a", "b", "c"]
    end
  end
end
