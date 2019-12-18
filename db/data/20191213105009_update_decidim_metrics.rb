class UpdateDecidimMetrics < ActiveRecord::Migration[5.2]

  # Source: https://github.com/decidim/decidim/blob/0.18-stable/CHANGELOG.md#0180
  def up
    days = (Date.parse(2.months.ago.to_s)..Date.yesterday).map(&:to_s)
    Decidim::Organization.find_each do |organization|
      old_metrics = Decidim::Metric.where(organization: organization, metric_type: "participants")
      days.each do |day|
        new_metric = Decidim::Metrics::ParticipantsMetricManage.new(day, organization)
        ActiveRecord::Base.transaction do
          old_metrics.where(day: day).delete_all
          new_metric.save
        end
      end
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
