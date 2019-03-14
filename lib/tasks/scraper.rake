namespace :scraper do
	desc "Scrape Reit Company"
	task reit_company_1: :environment do
		require 'open-uri'
		require 'nokogiri'
		require 'csv'
		require 'date'
		require 'json'
		# require "selenium-webdriver"

		max_page = 31
		c_names =[]
		c_directory = []
		max_page.times do |i|

			url =  "https://www.reit.com/investing/reit-directory?field_rtc_listing_status_tid_selective[0]=541&field_rtc_listing_status_tid_selective[1]=524&field_rtc_listing_status_tid_selective[2]=8000&field_address_country_selective[0]=US&sort_by=field_stock_return_30_value&page=#{i}"

			page = Nokogiri::HTML(open(url))

			company = page.css("div.name a")

			company.each do |line|
				c_names << line.text.strip
				puts c_names
			end

			company.each do |line|
				c_directory << line["href"]
			end

			# Company.create(
			# 	company_name: c_names, 
			# 	directory_url: c_directory
			# 	)
		

		end
		c_names.length.times do |i|
			Company.create(
				company_name: c_names[i], 
				directory_url: "https://www.reit.com" + c_directory[i].to_s
				)
		end
		# puts c_directory
		puts c_names
		puts c_directory.size

	end

	desc "Scrape Individual Company"
	task reit_company_2: :environment do
		require 'open-uri'
		require 'nokogiri'
		require 'csv'
		require 'date'
		require 'json'
		# require "selenium-webdriver"
		id = Company.count
		
		# company_type = []
		# listing_status = []
		id.times do |i|
			ci = "#{i+1}".to_i
			company = Company.find(ci)
			url = company.directory_url

			page = Nokogiri::HTML(open(url))


			company_type = page.css("div.investor__overview li:nth-child(1) .reit-values__value").text.strip
			listing_status = page.css("div.investor__overview li:nth-child(2) .reit-values__value").text.strip
			industry_sector = page.css("div.investor__overview li:nth-child(3) .reit-values__value").text.strip
			investment_sector = page.css("div.investor__overview li:nth-child(4) .reit-values__value").text.strip
			ticker = page.css("div.investor__overview li:nth-child(5) .reit-values__value").text.strip
			exchange = page.css("div.investor__overview li:nth-child(6) .reit-values__value").text.strip
			address = page.css(".reit-company-address__city-state , .reit-company-address__line-2 , .reit-company-address__line-1").text.strip
			phone = page.css(".reit-company-address__phone").text.strip
			website = page.css(".reit-company-address__website").text.strip

			company.update_attribute(:website, website)
			company.update_attribute(:company_type, company_type)
			company.update_attribute(:listing_status, listing_status)
			company.update_attribute(:industry_sector, industry_sector)
			company.update_attribute(:investment_sector, investment_sector)
			company.update_attribute(:ticker, ticker)
			company.update_attribute(:exchange, exchange)
			company.update_attribute(:address, address)
			company.update_attribute(:phone, phone)
			
			puts "Post Number: " + "#{i+1}".to_s

		end

	end

	desc "Scrape reitnotes list"
	task reitnotes: :environment do

		#url = "https://www.reitnotes.com/list-of-public-reits/"
		url = "https://www.reitnotes.com/list-public-non-listed-reits/"

		page = Nokogiri::HTML(open(url))

		company_name = page.css("td a")
		directory_url = page.css("td a")
		exchange = page.css("td:nth-child(3)")
		company_type = page.css("td:nth-child(4)")
		industry_sector = page.css("td:nth-child(5)")
		ticker = page.css("td:nth-child(1)")
		address = page.css("td:nth-child(6)")


		company = []
		dir_array = []
		exchange_array = []
		company_type_array = []
		industry_sector_array = []
		ticker_array = []
		address_array =[]

		company_name.each do |line|
			company << line.text.strip
			
		end
		directory_url.each do |line|
			directory = line["href"]
			dir_array << "https://www.reitnotes.com" + directory
		end

		exchange.each do |line|
			exchange_array << line.text.strip
		end

		company_type.each do |line|
			company_type_array << line.text.strip
		end
		industry_sector.each do |line|
			industry_sector_array << line.text.strip
		end
		ticker.each do |line|
			ticker_array << line.text.strip
		end
		address.each do |line|
			address_array << line.text.strip
		end
		company.length.times do |i|
			Company.create(
				company_name: company[i], 
				directory_url: dir_array[i],
				exchange: exchange_array[i],
				company_type: company_type_array[i],
				industry_sector: industry_sector_array[i],
				ticker: ticker_array[i],
				address: address_array[i]
			)
			p "#{i+1}".to_i
		end		
	end

	desc "Scrape reitnotes list"
	task reitnotes_sec: :environment do

		max_page = 23
		company = []
		dir_array = []
		ticker_array = []

		max_page.times do |i|

			url = "https://www.reitnotes.com/list-of-US-SEC-registered-reits-SIC-6798/All/p/#{i+1}"
			page = Nokogiri::HTML(open(url))

			company_name = page.css("td:nth-child(2)")
			directory_url = page.css("td:nth-child(1)")
			ticker = page.css("td:nth-child(1)")

			company_name.each do |line|
				company << line.text.strip
			end

			directory_url = page.css("td:nth-child(1)")
			directory_url.each do |e|
			  anchor = e.css('a')

			  directory = anchor.any? ? anchor[0]['href'] : '/link_not_found'

			  dir_array << "https://www.reitnotes.com" + directory
			end

			

			ticker.each do |line|
				ticker_array << line.text.strip
			end


		end

		company.length.times do |i|
			Company.create(
				company_name: company[i], 
				directory_url: dir_array[i],
				ticker: ticker_array[i],
			)
			p "#{i+1}".to_i
		end
	end

	desc "Scrape update_sec list"
	task update_sec: :environment do
		url = "https://www.reitnotes.com/list-of-US-SEC-registered-reits-SIC-6798/All/p/1"
		page = Nokogiri::HTML(open(url))

		directory_url = page.css("td:nth-child(1)")
		directory_url.each do |e|
		  anchor = e.css('a')

		  directory = anchor.any? ? anchor[0]['href'] : '(No URL)'
		  puts directory
		end

	end


	desc "Update Reitnotes list"
	task update_reitnotes: :environment do
		min = 249
		max = 1799
		(min..max).each { |i|

		
			begin
				company = Company.find(i)
				directory_url = company.directory_url

				page = Nokogiri::HTML(open(directory_url))

				exchange = page.at_css(".h4 a")
				# company_type = page.at_css(".h4 .blue:nth-child(12)")
				industry_sector = page.at_css(".h4 .blue:nth-child(18)")
				ticker = page.at_css(".blue:nth-child(1)")
				address = page.at_css(".h4 .blue:nth-child(10)")
				# list_status = page.at_css(".h4 .blue:nth-child(14)")
				# website = page.at_css(".col-sm-4 td:nth-child(1) a")
				# twitter = page.at_css("td:nth-child(2) a")
				# linkedin = page.at_css("td:nth-child(3) a")

				
				exchange_c = exchange.text.strip
				# company_type_c = company_type.text.strip
				industry_sector_c = industry_sector.text.strip
				ticker_c = ticker.text.strip
				address_c = address.text.strip
				# list_status_c = list_status.text.strip
				# website_c = website["href"]
				# twitter_c = twitter["href"]
				# linkedin_c = linkedin["href"]
			
				company.update_attribute(:exchange, exchange_c)
				# company.update_attribute(:company_type, company_type_c)
				company.update_attribute(:industry_sector, industry_sector_c)
				company.update_attribute(:ticker, ticker_c)
				company.update_attribute(:address, address_c)
				# company.update_attribute(:listing_status, list_status_c)
				# company.update_attribute(:website, website_c)
				# company.update_attribute(:twitter, twitter_c)
				# company.update_attribute(:linkedin, linkedin_c)

			rescue Exception => e
				puts e
			end

			puts "Sec " + "#{i}".to_s
		}

		

	end



	desc "Scrape reitnotes list"
	task remove_duplicate: :environment do
		remove_duplicate = Company.where.not(id: Company.group(:company_name).select("min(id)")).destroy_all

		puts remove_duplicate.size
	end

	desc "Scrape reitnotes list"
	task create_csv: :environment do
		require 'open-uri'
		require 'nokogiri'
		require 'csv'
		require 'date'
		require 'json'
		require "selenium-webdriver"

		company_name		 	= []
		directory_url		 	= []
		website 				= []
		description 			= []
		company_type 			= []
		listing_status 			= []
		industry_sector 		= []
		investment_sector 		= []
		exchange 				= []
		ticker 					= []
		address 				= []
		phone 					= []
		twitter 				= []
		linkedin 				= []


		companies = Company.all
		companies.each do |company|

		    company_name << company.company_name
		    directory_url << company.directory_url
		    website << company.website
		    description << company.description
		    company_type << company.company_type
		    listing_status << company.listing_status
		    industry_sector << company.industry_sector
		    investment_sector << company.investment_sector
		    exchange << company.exchange
		    ticker << company.ticker
		    address << company.address
		    phone << company.phone
		    twitter << company.twitter
		    linkedin << company.linkedin
		end
		CSV.open('db/seed/reit_content.csv', 'wb') do |file|
			file << ["company_name", "directory_url", "website", "description", "company_type", "listing_status", "industry_sector", "investment_sector", "exchange","ticker", "address", "phone", "twitter", "linkedin"]
			company_name.length.times do |i|
				file << [company_name[i], directory_url[i], website[i], description[i], company_type[i], listing_status[i], industry_sector[i], investment_sector[i], exchange[i],ticker[i], address[i], phone[i], twitter[i], linkedin[i]]

			puts "Post Number: " + "#{i}".to_s
			end
		end
		
	end




end