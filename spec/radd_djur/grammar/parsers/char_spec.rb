require "spec_helper"

describe Grammar::Parsers do
  describe "#char" do
    it "returns a Parser which parses the specified character" do
      d = Grammar::Derivs.new(nil, "abc")
      r = char(?a).parse(d).force
      expect(r.succeeded?).to eq true
      expect(r.value).to eq ?a
      expect(r.remainder.char.force.value).to eq ?b
      r2 = char(?b).parse(d).force
      expect(r2.succeeded?).to eq false
    end
  end
end
