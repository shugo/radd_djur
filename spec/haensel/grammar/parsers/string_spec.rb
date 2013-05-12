require "spec_helper"

describe Grammar::Parsers do
  describe "#string" do
    it "returns a Parser which parses the specified string" do
      d = Grammar::Derivs.new(nil, "abcdef")
      r = string("abc").parse(d).force
      expect(r.succeeded?).to eq true
      expect(r.value).to eq "abc"
      expect(r.remainder.char.force.value).to eq ?d
      r2 = string("abd").parse(d).force
      expect(r2.succeeded?).to eq false
    end

    it "returns a Parser which parses an empty string" do
      d = Grammar::Derivs.new(nil, "abcdef")
      r = string("").parse(d).force
      expect(r.succeeded?).to eq true
      expect(r.value).to eq ""
      expect(r.remainder.char.force.value).to eq ?a
      d2 = Grammar::Derivs.new(nil, "")
      r2 = string("").parse(d2).force
      expect(r2.succeeded?).to eq true
      expect(r2.value).to eq ""
      expect(r2.remainder.char.force).to eq Grammar::NO_PARSE
    end
  end
end
