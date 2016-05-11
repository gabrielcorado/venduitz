# Venduitz [![Build Status](https://travis-ci.org/gabrielcorado/venduitz.svg?branch=develop)](https://travis-ci.org/gabrielcorado/venduitz) [![Gem Version](https://badge.fury.io/rb/venduitz.svg)](https://badge.fury.io/rb/venduitz)
A simple JSON-only(until now) template engine, with focus on performance for better Restful-APIs.

## How to use it

### Install
```ruby
gem install venduitz
# OR...
gem 'venduitz'
```

### Define your views
```ruby
require 'venduitz'

class MetaView < Venduitz::View
  # Define the MEta view properties
  prop :current, -> (search) { search.current_page }
  prop :total, -> (search) { search.total_count }
  prop :total_pages
  prop :per_page
end

# Image view
class ImageView < Venduitz::View
  # Define the view properties
  prop :url
  prop :width
  prop :height
  prop :alt
end

# Product view
class ProductView < Venduitz::View
  # Define the view properties
  prop :name
  prop :sku
  prop :price

  # Also some collections
  collection :images, ImageView, value: -> (product) { product.variants.images }

  # You could also pass a property as a proc
  # In this case I will use the ImageView again
  prop :cover, -> (product) { ImageView.generate(product.cover) }
end

# Its also possible to exclude collection/prop values when generating it
# in this way you could generate a Ember-like result
class SearchView < Venduitz::View
  # Define the view properties
  prop :meta, -> (search) { MetaView.generate(search) }

  collection :products, ProductView, value: -> (search) { search.products }, exclude: [:images]
  collection :images, ImageView, value: -> (search) { search.products.images }
end

# Get your Object ready
search = Product.search 'Hello'

# Transform it to JSON!
res = SearchView.to_json(search)

# OR... If you don't want to show the images for this search
# just exclude them in the generation method
res = SearchView.to_json(search, [:images])

# Return to your framwork
[200, {'Content-Type' => 'application/json'}, res]
```

## Development
* Building the docker container: `docker build -t venduitz .`
* Running the tests:
  * With volume: `docker run --rm -it -v (PWD):/venduitz venduitz bundle exec rspec`
  * Without volume: `docker run --rm -it venduitz bundle exec rspec`
