class CreateDataMigrateTable < ActiveRecord::Migration[5.2]
  def change
    create_table :data_migrations, primary_key: "version", id: :string, force: :cascade do |t|
    end
  end
end
