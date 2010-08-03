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
    
    def all resource, options ={}
      check_configuration
      do_get(resource.rally_uri, parsed_options(options))
    end

    def get resource     
      check_configuration 
      JSON.parse(do_get(resource.rally_uri))[resource.class.to_s]    
    end
    
    def parsed_options options
      option_string = {}
      if options.has_key? :conditions
        option_string = option_string.merge(parsed_query(options[:conditions]))
      end
      
      if options.has_key? :start
        option_string = option_string.merge(parsed_start(options[:start]))
      end

      if options.has_key? :pagesize
        option_string = option_string.merge(parsed_pagesize(options[:pagesize]))
      end
      option_string
    end

    def parsed_start(start)
      {:start => start.to_i}
    end

    def parsed_pagesize(pagesize)
      {:pagesize => pagesize.to_i}
    end
    
    def parsed_query conditions
      tokens = conditions.collect{|k,v| query_token(k,v)}
      {:query => tokens.join(" and ")}
    end

    def query_token k,v
      operators ={
        "gt" => ">",
        "gte" => ">=",
        "lt" => "<",
        "lte" => "<=",
        "ne" => "!="}
      field = k.respond_to?("key") ? k.key : k
      operator = k.respond_to?("operator") ? operators[k.operator] : "="
      "( #{field.capitalize} #{operator} \"#{v}\" )"
    end

    def do_get uri, options = nil
      if options
        rally_resource[uri].get(options)
      else
        rally_resource[uri].get
      end
    end

    def rally_resource
      uri = "https://rally1.rallydev.com/slm/webservice/1.19"
      RestClient::Resource.new(uri, 
                               :user => self.configuration.user, 
                               :password => self.configuration.password)
    end

    def check_configuration
      if self.configuration.user.nil? ||  self.configuration.password.nil?
        raise CredentialsError.new 
      end
    end
  end
end
