# This script extracts the number unique users that have supported a proposal
# of the component provided in a period of time.
#
# Usage: bin/rails runner lib/reports/decidim_proposals_supports_summary.rb
#
# Parameters

decidim_component_id = 190

CSV.open("decidim_supports_#{decidim_component_id}_unique.csv", "wb") do |csv|
	csv << %w(from_date to_date supports)
	[28, 21, 14, 7].each do |days_ago|
		from_date = days_ago.days.ago.beginning_of_day
		from_date_s = from_date.strftime("%Y-%m-%d")
		to_date = from_date + 7.days
		to_date_s = to_date.strftime("%Y-%m-%d")

		ps = Decidim::Proposals::Proposal.where(decidim_component_id: decidim_component_id).order(id: :asc)

		supports = ps.flat_map{ |p| p.votes.where(created_at: from_date..to_date).pluck(:decidim_author_id) }.uniq.sort.size
		csv << [from_date_s, to_date_s, supports]
	end
end
