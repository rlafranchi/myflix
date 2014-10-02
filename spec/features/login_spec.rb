require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    visit login_path
    user = Fabricate(:user)
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button "Sign In"
    expect(page).to have_content user.name
  end
end
