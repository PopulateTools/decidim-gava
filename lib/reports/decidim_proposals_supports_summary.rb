decidim_component_id = 190
dates = ['2022-06-08', '2022-06-15', '2022-06-22', '2022-06-29']
to_date = Date.today
ps = Decidim::Proposals::Proposal.where(decidim_component_id: decidim_component_id)
date = Date.today.strftime("%Y-%m-%d")
CSV.open("decidim_supports_#{decidim_component_id}_summary.csv", "wb") do |csv|
	csv << %w(from_date to_date supports_from_impersonated supports_from_verified)
	dates.each do |date|
		from_date = Date.parse(date).beginning_of_day
		to_date = (from_date + 6.days).end_of_day
		users = ps.flat_map{ |p| p.votes.where(created_at: from_date..to_date).pluck(:decidim_author_id) }.sort.uniq
		supports_impersonated = users.select{ |user_id| Decidim::ImpersonationLog.exists?(decidim_user_id: user_id) }.size
		supports_verified = users.select{ |user_id| !Decidim::ImpersonationLog.exists?(decidim_user_id: user_id) }.size
		csv << [date, to_date.strftime("%Y-%m-%d"), supports_impersonated, supports_verified]
	end
end
