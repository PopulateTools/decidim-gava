# frozen_string_literal: true

module Decidim
  module UnedEngine
    class QueryHelper
      def self.care_proposals(organization)
        process = Decidim::ParticipatoryProcess.find_by(organization: organization)
        component = Decidim::Component.where(participatory_space: process)

        Decidim::Proposals::Proposal.select(
          "id, (regexp_matches(title, 'Cautela \\d{1,3}'))[1] AS custom_title, body"
        ).where(component: component).order("(regexp_matches(title, '\\d{1,3}'))[1] asc")
      end

      def self.proposal_short_title(proposal)
        proposal.title[/cautela \d{1,2}/i]
      end
    end
  end
end
