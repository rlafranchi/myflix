require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user variable" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
    it "sets :user to be new record" do
      get :new
      expect(assigns(:user)).to be_new_record
    end
  end
  describe "POST create" do
    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "should create the user" do
        expect(User.count).to eq(1)
      end
      it "should redirect to the sign in page" do
        expect(response).to redirect_to login_path
      end
    end
    context "with invalid input" do
      before do
        post :create, user: { email: "", password: "password", name: "Name" }
      end
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "render the :new template" do
        expect(response).to render_template :new
      end
      it "sets the @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
        expect(assigns(:user)).to be_new_record
      end
    end
    context "email sending" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      it "sends email" do
        ActionMailer::Base.deliveries.should_not be_empty
      end
      it "sends to recipient" do
        message = ActionMailer::Base.deliveries.last
        message.to.should eq([User.first.email])
      end
      it "has the right content" do
        message = ActionMailer::Base.deliveries.last
        message.body.should include(User.first.name)
      end
    end
  end
  describe "GET show" do
    context "with authenticated users" do
      let(:bob) { Fabricate(:user) }
      before { set_current_user }
      it "renders show template" do
        get :show, id: bob.id
        expect(response).to render_template :show
      end
      it "sets @user variable" do
        get :show, id: bob.id
        expect(assigns(:user)).to eq(bob)
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 3 }
    end
  end
end
