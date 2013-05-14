require "spec_helper"

describe Grammar::Parser do
  describe "#optional" do
    it "returns a Parser which represents zero or more consecutive repetitions of self" do
      opt_space = any_char.bind { |c|
        if /\s/.match(c)
          ret c
        else
          fail
        end
      }.optional
      d1 = Grammar::Derivs.new(nil, "")
      r1 = opt_space.parse(d1).force
      expect(r1.succeeded?).to eq true
      expect(r1.value).to eq nil
      d2 = Grammar::Derivs.new(nil, " ")
      r2 = opt_space.parse(d2).force
      expect(r2.succeeded?).to eq true
      expect(r2.value).to eq " "
      d3 = Grammar::Derivs.new(nil, "   ")
      r3 = opt_space.parse(d3).force
      expect(r3.succeeded?).to eq true
      expect(r3.value).to eq " "
    end
  end
end
