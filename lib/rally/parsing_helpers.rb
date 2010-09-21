module Rally
  module ParsingHelperClassMethods
    def node_name
      if self.to_s == "Story"
        "HierarchicalRequirement"
      else
        self.to_s
      end
    end

    def from_uri(uri)
      obj = first(:conditions => {:rally_uri => uri}) || new(:rally_uri => uri)
      obj.refresh
    end

    def rally_query options={}
      RallyAPI.all(self, options)
    end
  end

  module ParsingHelpers
    def raw_json options = {}
      options[:refresh] = options[:refresh] || false

      unless self.rally_uri
        raise "Could not fetch resource"
      end
      
      if @rally_hash
        return @rally_hash 
      else
        @rally_hash = get_fields_from_rally
      end
  
      @rally_hash
  
    end
  
    private

    def get_fields_from_rally
      rally_hash = RallyAPI.get(self)
      
      #special case for heirarchical_requirements
      if rally_hash.has_key? "HierarchicalRequirement"
        rally_hash = rally_hash["HierarchicalRequirement"]
      end

      rally_hash
    end

    #next 3 are for mapping from rally to mongo
    def from_rally attr, key=nil
      key = key || attr.to_s.capitalize
      self.send("#{attr.to_s}=", raw_json[key.to_s])
    end

    def parse_refs key, rally_objects
      if self.respond_to?(key) && !rally_objects.nil?
        self.send("#{key.to_s}=", rally_objects.collect{|i| i["_ref"]})
      end
    end
  
    def parse_ref key, rally_object  
      if self.respond_to?(key) && !rally_object.nil?
        self.send("#{key.to_s}=", rally_object["_ref"])
      end
    end
  end
end
