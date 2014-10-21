require 'spec_helper'

feature "Admin adds video" do
  scenario "Admin adds video" do
    admin = Fabricate(:admin)
    category = Fabricate(:category)
    sign_in(admin)
    visit new_admin_video_path
    fill_in "Name", with: "Monk"
    select category.name, from: "Category"
    fill_in "Description", with: "Description"
    attach_file "Large cover", "public/tmp/monk_large.jpg"
    attach_file "Small cover", "public/tmp/monk.jpg"
    fill_in "Video url", with: "http://youtu.be/hseWMRV3lA8"
    click_button "Add Video"

    visit logout_path
    sign_in

    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")
    expect(page).to have_selector("a[href='http://youtu.be/hseWMRV3lA8']")
  end
end
