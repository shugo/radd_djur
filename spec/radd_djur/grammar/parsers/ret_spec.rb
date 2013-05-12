require "spec_helper"

describe Grammar::Parsers do
  describe "#ret" do
    it "returns a Parser which yields the argument" do
      p123 = ret(123)
      d = Grammar::Derivs.new(nil, "abc")
      r = p123.parse(d).force
      expect(r.succeeded?).to eq true
      expect(r.value).to eq 123
      expect(r.remainder.char.force.value).to eq ?a
    end
  end
end
