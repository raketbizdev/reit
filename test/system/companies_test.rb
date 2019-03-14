require "application_system_test_case"

class CompaniesTest < ApplicationSystemTestCase
  setup do
    @company = companies(:one)
  end

  test "visiting the index" do
    visit companies_url
    assert_selector "h1", text: "Companies"
  end

  test "creating a Company" do
    visit companies_url
    click_on "New Company"

    fill_in "Address", with: @company.address
    fill_in "Company name", with: @company.company_name
    fill_in "Company type", with: @company.company_type
    fill_in "Description", with: @company.description
    fill_in "Directory url", with: @company.directory_url
    fill_in "Exchange", with: @company.exchange
    fill_in "Industry sector", with: @company.industry_sector
    fill_in "Investment sector", with: @company.investment_sector
    fill_in "Listing status", with: @company.listing_status
    fill_in "Phone", with: @company.phone
    fill_in "Ticker", with: @company.ticker
    fill_in "Website", with: @company.website
    click_on "Create Company"

    assert_text "Company was successfully created"
    click_on "Back"
  end

  test "updating a Company" do
    visit companies_url
    click_on "Edit", match: :first

    fill_in "Address", with: @company.address
    fill_in "Company name", with: @company.company_name
    fill_in "Company type", with: @company.company_type
    fill_in "Description", with: @company.description
    fill_in "Directory url", with: @company.directory_url
    fill_in "Exchange", with: @company.exchange
    fill_in "Industry sector", with: @company.industry_sector
    fill_in "Investment sector", with: @company.investment_sector
    fill_in "Listing status", with: @company.listing_status
    fill_in "Phone", with: @company.phone
    fill_in "Ticker", with: @company.ticker
    fill_in "Website", with: @company.website
    click_on "Update Company"

    assert_text "Company was successfully updated"
    click_on "Back"
  end

  test "destroying a Company" do
    visit companies_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Company was successfully destroyed"
  end
end
