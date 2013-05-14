require "spec_helper"

using RaddDjur::DSL

describe DSL do
  describe "Object#to_parser" do
    it "raises a TypeError" do
      expect {
        Object.new.to_parser
      }.to raise_error TypeError
    end
  end
end
