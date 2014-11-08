feature "User interacts with social networking" do
  scenario "appropriate followers show on people page" do
    comedies = Fabricate(:category, name: "Comedies")
    south_park = Fabricate(:video, name: "South Park", small_cover: '/tmp/south_park.jpg', category: comedies)
    family_guy = Fabricate(:video, name: "Family Guy", small_cover: '/tmp/family_guy.jpg', category: comedies)
    futurama = Fabricate(:video, name: "Futuram", small_cover: '/tmp/futurama.jpg', category: comedies)
    bob = Fabricate(:user)
    review = Fabricate(:review, user: bob, video: futurama, rating: 5, content: "good")
    user = Fabricate(:user)
    sign_in(user)

    visit videos_path

    find("a[href='/videos/#{futurama.id}']").click
    page.should have_content bob.name

    click_link bob.name
    page.should have_content bob.name

    click_link "Follow"
    page.should have_content bob.name

    visit user_path(bob)
    page.should_not have_content "Follow"

    visit people_path
    relationship = Relationship.find_by(leader_id: bob.id, follower_id: user.id)
    find("a[href='/relationships/#{relationship.id}']").click
    page.should_not have_content bob.name

    visit user_path(user)
    page.should_not have_content "Follow"
  end
end
