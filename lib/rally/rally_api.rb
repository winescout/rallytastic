class RallyAPI
  class Configure
    attr_accessor :user, :password
  end

  class CredentialsError < RestClient::Unauthorized; end

  class << self
    @configuration = nil

    def configure(&block)
      @configuration = @configuration || Configure.new
      yield @configuration
    end

    def configuration
      @configuration
    end

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
      if self.configuration.user.nil? ||  self.configuration.password.nil?
        raise CredentialsError.new 
      end
      uri = "https://rally1.rallydev.com/slm/webservice/1.19"
      RestClient::Resource.new(uri, 
                               :user => self.configuration.user, 
                               :password => self.configuration.password)
    end
  end
end
