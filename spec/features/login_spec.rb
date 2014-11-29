require 'spec_helper'

feature "user signs in" do
  scenario "with valid email and password" do
    visit login_path
    user = Fabricate(:user)
    sign_in(user)
    expect(page).to have_content user.name
  end
  scenario "deactivated account" do
    user = Fabricate(:user, active: false)
    sign_in(user)
    expect(page).to_not have_content user.name
  end
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  click_button "Sign In"
end
