# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'
CSV.foreach('db/seed/reit_content.csv', headers: true) do |row|
	Company.create(
	    company_name: row[0],
	    directory_url: row[1],
	    website: row[2],
	    description: row[3],
	    company_type: row[4],
	    listing_status: row[5],
	    industry_sector: row[6],
	    investment_sector: row[7],
	    exchange: row[8],
	    ticker: row[9],
	    address: row[10],
	    phone: row[11],
	    twitter: row[12],
	    linkedin: row[13]
	)

	puts "Post: " + "#{$.}".to_s
end