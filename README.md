# SnapdealApi

Utility class to pull data from snapdeal.com using Snapdeal's affiliate APIs http://affiliate.snapdeal.com/affiliate/api/product/feeds/.

Inspired by https://github.com/deepakhb2/flipkart_api

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snapdeal_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snapdeal_api

## Usage

require 'snapdeal_api'

sd_api = SnapdealApi.new(Snapdeal-Affiliate-Id, Snapdeal-Token-Id, format) #format : json/xml

categories_string = sd_api.get_categories(optional format) #format : json/xml is optional, if not passed will use the one from new

categories = sd_api.get_parsed_categories

rest_url = sd_api.get_products_api(category_name) #Name is as present in the categories

products_string = sd_api.get_products_by_category(category_name) #Name is as present in categories. Returns upto first 500 products in the format specified while creating new object

products_string = sd_api.get_products(rest_url, optional format) #format : json/xml, if not passed will use the one from new

products_array = sd_api.get_all_products(rest_url) This method will fetch all the products in this category, in an array of JSON data. Warning: This implemenation is for reference, handle with care


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

