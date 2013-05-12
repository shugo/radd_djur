require "spec_helper"

using RaddDjur::DSL

describe Grammar do
  describe "#parse" do
    it "converts a plain object to a parser" do
      grammar = Grammar.new(:sequence) {
        define :sequence, "foo"
      }
      expect(grammar.parse("foo")).to eq "foo"
      expect {
        grammar.parse("bar")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse("")
      }.to raise_error Grammar::ParseError
    end

    it "supports bind" do
      grammar = Grammar.new(:sequence) {
        define :sequence do
          "foo".bind {
            "bar".bind {
              "baz"
            }
          }
        end
      }
      expect(grammar.parse("foobarbaz")).to eq "baz"
      expect {
        grammar.parse("foobar")
      }.to raise_error Grammar::ParseError
      expect {
        grammar.parse("baz")
      }.to raise_error Grammar::ParseError
    end

    it "supports /" do
      grammar = Grammar.new(:alternatives) {
        define :alternatives do
          "foo" / "bar" / "baz"
        end
      }
      expect(grammar.parse("foo")).to eq "foo"
      expect(grammar.parse("bar")).to eq "bar"
      expect(grammar.parse("baz")).to eq "baz"
      expect {
        grammar.parse("quux")
      }.to raise_error Grammar::ParseError
    end
  end
end
