require 'spec_helper'

feature "User resets password" do
  scenario "user successfully resets password" do
    joe = Fabricate(:user)
    visit login_path
    click_link "Lost Password?"
    fill_in :email, with: joe.email
    click_button "Send Email"
    open_email(joe.email)
    current_email.click_link "Reset Password"
    fill_in :password, with: "new_password"
    click_button "Reset Password"
    fill_in :email, with: joe.email
    fill_in :password, with: "new_password"
    click_button "Sign In"
    page.should have_content "Welcome, #{joe.name}"
  end
end
