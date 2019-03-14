class AddFieldsToCompanies < ActiveRecord::Migration[5.2]
  def change
    add_column :companies, :twitter, :string
    add_column :companies, :linkedin, :string
  end
end
