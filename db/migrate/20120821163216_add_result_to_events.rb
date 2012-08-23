class AddResultToEvents < ActiveRecord::Migration
  def change
    add_column :events, :result, :string
  end
end
