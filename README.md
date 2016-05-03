# Venduitz
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
  collection :images, ImageView, -> (product) { product.variants.images }

  # You could also pass a property as a proc
  # In this case I will use the ImageView again
  prop :cover, -> (product) { ImageView.generate(product.cover) }
end

# Get your Object ready
product = Product.first

# Transform it to JSON!
res = ProductView.to_json(product)

# Return to your framwork
[200, {'Content-Type' => 'application/json'}, res]
```

## Development
* Building the docker container: `docker build -t venduitz .`
* Running the tests:
  * With volume: `docker run --rm -it -v (PWD):/venduitz venduitz bundle exec rspec`
  * Without volume: `docker run --rm -it venduitz bundle exec rspec`
