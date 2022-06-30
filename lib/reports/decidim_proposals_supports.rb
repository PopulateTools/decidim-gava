# This script extracts the number of supports for each proposal of the component provided
# in a period of time.
#
# Usage: bin/rails runner lib/reports/decidim_proposals_supports.rb
#
# Parameters
decidim_component_id = 190
from_date = 14.days.ago.beginning_of_day
to_date = from_date + 7.days



ps = Decidim::Proposals::Proposal.where(decidim_component_id: decidim_component_id)
date = Date.today.strftime("%Y-%m-%d")
CSV.open("decidim_supports_#{decidim_component_id}_20220621.csv", "wb") do |csv|
	csv << %w(date reference title supports)
	ps.each do |p|
		supports = p.votes.where(created_at: from_date..to_date).pluck(:decidim_author_id).sort.uniq.size
		csv << [date, p.reference, p.title['ca'] || p.title['es'], supports]
	end
end
