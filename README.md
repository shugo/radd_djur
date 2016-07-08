radd\_djur - Packrat parser combinator library for Ruby
=======================================================

Packrat parser combinator library for Ruby

Install
-------

```bash
$ gem install radd_djur
```

Documentation
-------------

* [API Reference](http://www.rubydoc.info/github/shugo/radd_djur/master)

Example
-------

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
        :multitive.bind { |x|
          "+".bind {
            :additive.bind { |y|
              ret x + y
            }
          }
        } / :multitive
      end

      # multitive <- primary '*' multitive / primary
      define :multitive do
        :primary.bind { |x|
          "*".bind {
            :multitive.bind { |y|
              ret x * y
            }
          }
        } / :primary
      end

      # primary <- '(' additive ')' / digits
      define :primary do
        "(".bind {
          :additive.bind { |x|
            ")".bind {
              ret x
            }
          }
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

License
-------

(The MIT License)

Copyright (c) 2013 Shugo Maeda

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
