require "spec_helper"

describe Grammar::Parsers do
  describe "#fail" do
    it "returns a Parser which yields NO_PARSE" do
      d = Grammar::Derivs.new(nil, "abc")
      r = fail.parse(d)
      expect(r).to eq Grammar::NO_PARSE
    end
  end
end
