require 'spec_helper'
require 'pry'

feature "User interacts with queue" do
  scenario "does not duplicate queue item user adds and reorders videos in queue" do
    comedies = Fabricate(:category, name: "Comedies")
    south_park = Fabricate(:video, name: "South Park", small_image_url: '/tmp/south_park.jpg', category: comedies)
    family_guy = Fabricate(:video, name: "Family Guy", small_image_url: '/tmp/family_guy.jpg', category: comedies)
    futurama = Fabricate(:video, name: "Futuram", small_image_url: '/tmp/futurama.jpg', category: comedies)

    sign_in

    queues = [family_guy, south_park, futurama]

    queues.each do |queue|
      add_video_to_queue(queue)
      expect_video_in_queue(queue)
      expect_add_queue_not_seen(queue)
    end

    visit my_queue_path

    set_video_list_order(family_guy, 3)
    set_video_list_order(futurama, 2)
    set_video_list_order(south_park, 1)

    click_button "Update Instant Queue"

    expect_video_list_order(family_guy, 3)
    expect_video_list_order(futurama, 2)
    expect_video_list_order(south_park, 1)

  end

  scenario ""

  def expect_video_in_queue(video)
    expect(page).to have_content video.name
  end

  def expect_add_queue_not_seen(video)
    visit video_path(video)
    page.should_not have_content "+ My Queue"
  end

  def add_video_to_queue(video)
    visit videos_path
    find("a[href='/videos/#{video.id}']").click
    click_link("+ My Queue")
  end

  def set_video_list_order(video, list_order)
    within(:xpath, "//tr[contains(.,'#{video.name}')]") do
      fill_in "up_queue_items[][list_order]", with: list_order
    end
  end

  def expect_video_list_order(video, list_order)
    expect(find(:xpath, "//tr[contains(.,'#{video.name}')]//input[@type='text']").value).to eq(list_order.to_s)
  end
end
