require "snapdeal_api/version"

require "rest-client"
require "json"
require "nokogiri"

class SnapdealApi

    # Initialise object with affiliate id, token and format to send api calls
    def initialize(sd_affiliate_id, sd_affiliate_token, format="json")
        @api = "http://affiliate-feeds.snapdeal.com/feed/#{sd_affiliate_id}"
        @header = {"Snapdeal-Affiliate-Id" => sd_affiliate_id, "Snapdeal-Token-Id" => sd_affiliate_token}
        @format = format
        @categories = {} #cache: avoid subsequent requests
        @parsed_categories = {}
        @version = "v1"
    end

    # Get all the categories list, in xml/json format
    def get_categories(format = nil)
        ext = format.nil? ? @format : format
        rest_url="#{@api}.#{ext}"
        @categories = RestClient.get rest_url
    end

    # Get all the categories list, as key=>value pair
    def get_parsed_categories
        if @categories.empty?
            get_categories
        end
        set_parsed_categories(@categories)
        return @parsed_categories
    end

    def set_parsed_categories(categories)
        if categories.start_with? "{"
            @parsed_categories = parse_json categories
        elsif categories.start_with? "<?xml"
            @parsed_categories = parse_xml categories
        else
            raise "Wrong categories format, can't parse"
        end
    end

    def parse_json(categories)
        cats = JSON.parse(categories)
        categories_hash = {}
        cats['apiGroups']['Affiliate']['listingsAvailable'].each do |k,v|
            categories_hash[k] = v['listingVersions'][@version]['get']
        end
        return categories_hash
    end

    def parse_xml(categories)
        categories_hash = {}
        @doc = Nokogiri::XML(categories)
        @doc.xpath("//groupListings/apiGroups/entry/value/listingsAvailable/entry").each do |list|
            if list.xpath("value/listingVersions/entry/key").text == @version
                categories_hash[list.xpath("key").text] = list.xpath("value/listingVersions/entry/value/get").text
            end
        end
        return categories_hash
    end

    #Get the rest api url for the given category name
    def get_products_api(category)
        if @parsed_categories.empty?
            get_parsed_categories
        end
        @parsed_categories[category]
    end

    #Get the first 500 products from the category name
    #Output will also contain "nextUrl" which inturn returns next 500 products.
    def get_products_by_category(category)
        get_products(get_products_api(category))
    end

    #Get the products from given rest url
    def get_products(rest_url, format = nil)
        format = format.nil? ? @format : format
        header = @header
        if format == "json" || format == "xml"
            header['Accept'] = "application/#{format}"
        else
            raise "Wrong format: #{format} provided"
        end

        rest_output = RestClient.get rest_url, header
    end

    #Get all the products from given rest url
    #returns an array of products
    def get_all_products(rest_url)
        json_arr = []
        json_data = JSON.parse(get_products(rest_url, "json"))
        json_arr << [json_data]
        while json_data["nextUrl"]
            json_data = JSON.parse(get_products(json_data["nextUrl"], "json"))
            json_arr << [json_data]
            break
        end
        jsonout = json_arr
  end

end
