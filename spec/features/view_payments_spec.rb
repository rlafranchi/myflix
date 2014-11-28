require 'spec_helper'

feature "admin views payments" do
  background do
    alice = Fabricate(:user, name: "Alice Doe", email: "alice@example.com")
    payment = Fabricate(:payment, amount: 999, user: alice)
  end
  scenario "admin can see payments" do
    admin = Fabricate(:admin)
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content("$9.99")
    expect(page).to have_content("Alice Doe")
    expect(page).to have_content("alice@example.com")
  end
  scenario "user cannot see payments" do
    user = Fabricate(:user)
    sign_in(user)
    visit admin_payments_path
    expect(page).to_not have_content("$9.99")
    expect(page).to_not have_content("Alice Doe")
    expect(page).to have_content("You do not have administrative privileges.")
  end
end

def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit login_path
  fill_in :email, with: user.email
  fill_in :password, with: user.password
  click_button "Sign In"
end
