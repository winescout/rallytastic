class RallyAPI
  class << self
    def get resource      
      uri = resource.rally_uri || [endpoint(resource), uri_extension].join(".")
      JSON.parse(rally_resource[uri].get)[resource.class.to_s]    
    end
    
    def endpoint resource
      if resource.respond_to? "endpoint"
        endpoint = resource.endpoint
      else
        endpoint = ["/",resource.class.to_s.downcase].join
      end
      
      #if we are fetching an instance, add the objectID
      if resource.respond_to? "rally_id"
        endpoint = [endpoint, resource.rally_id].join("/")
      end
      endpoint
    end
    
    def uri_extension
      "js"
    end

    def rally_resource
      uri = "https://rally1.rallydev.com/slm/webservice/1.19"
      RestClient::Resource.new(uri, 
                               :user => 'xxx', 
                               :password => 'xxx')
    end
  end
end
