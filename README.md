radd\_djur - Packrat parser combinator library for Ruby
=======================================================

This project aims to provide immutable data structures for Ruby.

Install
-------

```bash
$ gem install radd_djur
```

Documentation
-------------

* [API Reference](http://rubydoc.info/github/shugo/radd_djur/frames)

Example
-------

    require "radd_djur"

    using RaddDjur::DSL

    g = RaddDjur::Grammar.new(:additive) {
      define :additive do
        :multitive.bind { |x|
          "+".bind {
            :additive.bind { |y|
              ret x + y
            }
          }
        } /
        :multitive
      end

      define :multitive do
        :primary.bind { |x|
          "*".bind {
            :multitive.bind { |y|
              ret x * y
            }
          }
        } /
        :primary
      end

      define :primary do
        "(".bind {
          :additive.bind { |x|
            ")".bind {
              ret x
            }
          }
        } /
        :digits
      end

      define :digits do
        :digit.bind { |x|
          :digits.bind { |y|
            ret (x + y.to_s).to_i
          }
        } /
        :digit.bind { |x|
          ret x.to_i
        }
      end

      define :digit, ?0..?9
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
