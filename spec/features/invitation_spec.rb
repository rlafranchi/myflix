require 'spec_helper'

feature 'Invitation' do
  scenario "user send invitation", { js: true, vcr: true } do
    sign_in
    visit new_invitation_path
    fill_in "Friend's Name", with: "Joe Schmoe"
    fill_in "Friend's Email Address", with: "Joe@schmoe.com"
    fill_in "Invitation Message", with: "Your a schmoe"
    click_button "Send Invitation"
    page.should have_content "Invitation sent"
    visit logout_path
    open_email('Joe@schmoe.com')
    current_email.click_link "Sign up"
    fill_in "Password", with: "password"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "7 - July", from: "Expiration Month"
    select "2016", from: "Expiration Year"
    click_button "Register"
    fill_in "Password", with: "password"
    fill_in "Email Address", with: "Joe@schmoe.com"
    click_button "Sign In"
    page.should have_content "Welcome, Joe Schmoe"
    clear_email
  end
end
