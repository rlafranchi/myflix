require 'spec_helper'

feature 'User registers', {js: true, vcr: true} do
  background do
    visit register_path
  end
  scenario "with valid user info and valid card" do
    fill_in_valid_user
    fill_in_valid_card
    click_button "Register"
    expect(page).to have_content('Thank You for signing up! Please sign in.')
  end
  scenario "with valid user info and invalid do card" do
    fill_in_valid_user
    fill_in_invalid_card
    click_button "Register"
    expect(page).to have_content('This card number looks invalid')
  end
  scenario "with valid user info and declined card" do
    fill_in_valid_user
    fill_in_declined_card
    click_button "Register"
    expect(page).to have_content('Your card was declined')
  end
  scenario "with invalid user info and valid card" do
    fill_in_invalid_user
    fill_in_valid_card
    click_button "Register"
    expect(page).to have_content('Invalid user information')
  end
  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user
    fill_in_invalid_card
    click_button "Register"
    expect(page).to have_content('This card number looks invalid')
  end
  scenario "with invalid user info and declined card" do
    fill_in_invalid_user
    fill_in_declined_card
    click_button "Register"
    expect(page).to have_content('Invalid user information')
  end

  def fill_in_valid_user
    fill_in "Email", with: 'test@example.com'
    fill_in "Password", with: 'password'
    fill_in "Name", with: 'Some Name'
  end

  def fill_in_valid_card
    fill_in "Credit Card Number", with: '4242424242424242'
    fill_in "Security Code", with: '123'
    select '12 - December', from: 'Expiration Month'
    select '2015', from: 'Expiration Year'
  end

  def fill_in_invalid_user
    fill_in "Email", with: ''
    fill_in "Password", with: 'password'
    fill_in "Name", with: 'Some Name'
  end

  def fill_in_invalid_card
    fill_in "Credit Card Number", with: '424'
    fill_in "Security Code", with: '123'
    select '12 - December', from: 'Expiration Month'
    select '2015', from: 'Expiration Year'
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: '4000000000000002'
    fill_in "Security Code", with: '123'
    select '12 - December', from: 'Expiration Month'
    select '2015', from: 'Expiration Year'
  end
end
