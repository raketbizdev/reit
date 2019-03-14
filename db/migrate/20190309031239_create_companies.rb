class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :directory_url
      t.string :website
      t.text :description
      t.string :company_type
      t.string :listing_status
      t.string :industry_sector
      t.string :investment_sector
      t.string :exchange
      t.string :ticker
      t.text :address
      t.string :phone

      t.timestamps
    end
  end
end
