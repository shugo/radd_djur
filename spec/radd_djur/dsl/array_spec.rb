require "spec_helper"

using RaddDjur::DSL

describe DSL do
  describe "Array#bind" do
    it "binds all elements" do
      grammar = Grammar.new(:additive) {
        define :additive do
          [?0..?9, "+", ?0..?9].bind { |x, *, y| ret x.to_i + y.to_i }
        end
      }
      expect(grammar.parse("1+2")).to eq 3
      expect(grammar.parse("0+7")).to eq 7
      expect {
        grammar.parse("1")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse("1+")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse("a+b")
      }.to raise_error Grammar::ParseError
    end
  end
end
