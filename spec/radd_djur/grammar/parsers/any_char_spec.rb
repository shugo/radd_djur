require "spec_helper"

describe Grammar::Parsers do
  describe "#any_char" do
    it "returns a Parser which parses any character" do
      d = Grammar::Derivs.new(nil, "abc")
      r = any_char.parse(d).force
      expect(r.succeeded?).to eq true
      expect(r.value).to eq ?a
      expect(r.remainder.char.force.value).to eq ?b
    end
  end
end
