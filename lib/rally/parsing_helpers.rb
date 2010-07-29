module Rally
  module ParsingHelperClassMethods
    def from_uri(uri)
      obj = first(:rally_uri => uri) || new(:rally_uri => uri)
      obj.refresh
    end
  end

  module ParsingHelpers
    def raw_json options = {}
      options[:refresh] = options[:refresh] || false

      unless self.rally_id || self.rally_uri
        raise "Could not fetch resource"
      end

      if options[:refresh] || self.rally_hash.empty?
          self.rally_hash = RallyAPI.get(self)
      end
  
      self.rally_hash
  
    end
  
    private
    #Objects from rally have a list of uris that hang off of them
    #This updates all the members of that list
    #and removes stale members
    def refresh_list klass, reference, uris
      existing = klass.all(reference => self.rally_uri)
      uris.each do |uri|
        klass.from_uri(uri)
      end
      
      #remove stale children
      stale = existing.reject{|obj| uris.include? obj.rally_uri}
      stale.each{|stale| stale.delete}
    end
    
    def parse_refs key, rally_objects
      if self.respond_to? key
        self.send("#{key.to_s}=", rally_objects.collect{|i| i["_ref"]})
      end
    end
  
    def parse_ref key, rally_object
  
      if self.respond_to? key
        self.send("#{key.to_s}=", rally_object["_ref"])
      end
    end
  end
end
