require "spec_helper"

using RaddDjur::DSL

describe DSL do
  describe "Symbol#to_parser" do
    it "converts a symbol to a parser" do
      grammar = Grammar.new(:foo) {
        define :foo, :string_foo
        define :string_foo, "foo"
      }
      expect(grammar.parse("foo")).to eq "foo"
      expect {
        grammar.parse("bar")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse("")
      }.to raise_error Grammar::ParseError
    end
  end
end
