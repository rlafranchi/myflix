shared_examples "requires sign in" do
  it "redirects to the sign in path" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to login_path
  end
end
shared_examples "requires admin" do
  it "redirects to the root path" do
    session[:user_id] = Fabricate(:user).id
    action
    expect(response).to redirect_to root_path
  end
end
