require 'spec_helper'

feature 'Invitation' do
  scenario "user send invitation" do
    sign_in
    click_link "Invite a Friend"
    fill_in "Friend's Name", with: "Joe Schmoe"
    fill_in "Friend's Email Address", with: "Joe@schmoe.com"
    fill_in "Invitation Message", with: "Your a schmoe"
    click_button "Send Invitation"
    page.should have_content "Invitation sent"
    open_email('Joe@schmoe.com')
    current_email.click_link "Sign up"
    fill_in "Password", with: "password"
    click_button "Sign Up"
    fill_in "Password", with: "password"
    fill_in "Email Address", with: "Joe@schmoe.com"
    click_button "Sign In"
    page.should have_content "Welcome, Joe Schmoe"
    clear_email
  end
end
