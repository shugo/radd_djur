require "spec_helper"

describe Grammar::Parsers do
  describe "#char" do
    it "returns a Parser which parses the specified character" do
      d = Grammar::Derivs.new(nil, "abc")
      r = char(?a).parse(d)
      expect(r.succeeded?).to eq true
      expect(r.value).to eq ?a
      expect(r.remainder.char.value).to eq ?b
      r2 = char(?b).parse(d)
      expect(r2.succeeded?).to eq false
    end
  end
end
