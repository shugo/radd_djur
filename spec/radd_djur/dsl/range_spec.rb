require "spec_helper"

using RaddDjur::DSL

describe DSL do
  describe "Range#to_parser" do
    it "converts a range object to a parser for a single character within the specified range" do
      grammar = Grammar.new(:foo) {
        define :foo, ?0..?9
      }
      for c in "0".."9"
        expect(grammar.parse(c)).to eq c
      end
      expect {
        grammar.parse("a")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse("/")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse(":")
      }.to raise_error Grammar::ParseError
    end
  end
end
