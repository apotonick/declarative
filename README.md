# Declarative

_DSL for nested schemas._

# Overview

Declarative allows _declaring_ nested schemas.

```ruby
class Schema < Declarative::Schema
  property :title

  property :songs do
    property :id
    property :name
  end
end
```

It also lets you define schemas in modules.

Declarative is the generic schema engine in Representable, Disposable, Trailblazer, and many more gems.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'declarative'
```


## Copyright

* Copyright (c) 2015 Nick Sutterer <apotonick@gmail.com>