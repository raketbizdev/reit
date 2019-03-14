json.extract! company, :id, :company_name, :directory_url, :website, :description, :company_type, :listing_status, :industry_sector, :investment_sector, :exchange, :ticker, :address, :phone, :created_at, :updated_at
json.url company_url(company, format: :json)
