module Parser
  class Madison < Base    
    def sized_on
      first_revision_date_matching /TASK ESTIMATE TOTAL changed from \[0.0\]/
    end

    def prioritized_on
      last_revision_date_matching /PROJECT changed from \[[^\]]*\] to \[Madison\]/
    end

    def started_on
      last_revision_date_matching /ITERATION added/
    end

    def completed_on
      last_revision_date_matching /SCHEDULE STATE changed from \[[^\]]*\] to [Complete]/
    end

    def accepted_on
      last_revision_date_matching /SCHEDULE STATE changed from \[[^\]]*\] to [Accepted]/
    end    
  end
end
