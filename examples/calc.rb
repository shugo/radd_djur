require_relative "../lib/radd_djur"

require "radd_djur"

# Activate refinements for radd_djur DSL.
# In the DSL, a Ruby symbol represents a nonterminal symbol, and a Ruby
# string represents a terminal symbol.
using RaddDjur::DSL

# Define a new grammar, whose start symbol is additive.
g = RaddDjur::Grammar.new(:additive) {

  # Grammar#define defines a new parsing rule for a nonterminal symbol.
  # The first argument is the name of the nonterminal symbol.
  # In the following comments, parsing rules are expressed in PEG.

  # additive <- multitive '+' additive / multitive
  define :additive do
    [:multitive, "+", :additive].bind { |x, *, y|
      ret x + y
    } / :multitive
  end

  # multitive <- primary '*' multitive / primary
  define :multitive do
    [:primary, "*", :multitive].bind { |x, *, y|
      ret x * y
    } / :primary
  end

  # primary <- '(' additive ')' / digits
  define :primary do
    ["(", :additive, ")"].bind { |_, x, _|
      ret x
    } / :digits
  end

  # digits <- [0-9]+
  define :digits do
    (?0..?9).one_or_more.bind { |xs|
      ret xs.foldl1(&:+).to_i
    }
  end
}
p g.parse("2*(3+4)")
