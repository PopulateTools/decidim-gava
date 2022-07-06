decidim_component_id = 190
dates = ['2022-06-08', '2022-06-15', '2022-06-22', '2022-06-29']
ps = Decidim::Proposals::Proposal.where(decidim_component_id: decidim_component_id)
date = Date.today.strftime("%Y-%m-%d")
CSV.open("decidim_supports_#{decidim_component_id}.csv", "wb") do |csv|
	csv << %w(from_date to_date reference title supports_from_impersonated supports_from_verified)
	dates.each do |date|
		from_date = Date.parse(date).beginning_of_day
		to_date = (from_date + 6.days).end_of_day
		ps.each do |p|
			supports = p.votes.where(created_at: from_date..to_date)
			supports_impersonated = supports.select{ |s| Decidim::ImpersonationLog.exists?(decidim_user_id: s.decidim_author_id) }.map(&:decidim_author_id).sort.uniq.size
			supports_verified = supports.select{ |s| !Decidim::ImpersonationLog.exists?(decidim_user_id: s.decidim_author_id) }.map(&:decidim_author_id).sort.uniq.size

			csv << [date, to_date.strftime("%Y-%m-%d"), p.reference, p.title['ca'] || p.title['es'], supports_impersonated, supports_verified]
		end
	end
end
