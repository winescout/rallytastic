module Rally
  module Parser
    class Base
      attr_accessor :story
      def initialize story
        @story = story
      end
  
      def revisions
        @story.revisions
      end
      
      protected
      def latest_revision_date_matching regexp
        revision = revisions.desc(:created_on).select{|r| r.description =~ regexp}.first
        revision.created_on if revision
      end
  
      def first_revision_date_matching regexp
        revision = revisions.asc(:created_on).select{|r| r.description =~ regexp}.first
        revision.created_on if revision
      end
    end
  end
end
