require 'spec_helper'
require 'pry'
describe RelationshipsController do
  describe "GET index" do
    context "with authenticated users" do
      it "sets @relationships variable" do
        bob = Fabricate(:user)
        session[:user_id] = bob.id
        alice = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: bob, leader: alice)
        get :index
        expect(assigns(:relationships)).to eq([relationship])
      end
      it "renders index template" do
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end
  describe "DELETE destroy" do
    context "with authenticated users" do
      let(:bob) { current_user }
      before { set_current_user }
      it "redirects to people page" do
        alice = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: bob, leader: alice)
        delete :destroy, id: relationship.id
        expect(response).to redirect_to people_path
      end
      it "deletes the relationship" do
        alice = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: bob, leader: alice)
        delete :destroy, id: relationship.id
        expect(bob.following_relationships).to eq([])
      end
      it "does not delete relationship if the current user is not the follower" do
        alice = Fabricate(:user)
        john = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: bob, leader: alice)
        relationship2 = Fabricate(:relationship, follower: john, leader: alice)
        delete :destroy, id: relationship2.id
        expect(john.following_relationships).to eq([relationship2])
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 4 }
    end
  end
  describe "POST create" do
    context "with authenticated users" do
      let(:bob) { current_user }
      before { set_current_user }
      it "redirects to people page" do
        alice = Fabricate(:user)
        post :create, relationship: {leader_id: alice.id}
        expect(response).to redirect_to people_path
      end
      it "creates relationship" do
        alice = Fabricate(:user)
        post :create, relationship: {leader_id: alice.id}
        expect(Relationship.count).to eq(1)
      end
      it "does not create a reltionship if leader is current user" do
        post :create, relationship: {leader_id: bob.id}
        expect(Relationship.count).to eq(0)
      end
      it "does not creat a relationship if current user is already following the leader" do
        alice = Fabricate(:user)
        relationship = Fabricate(:relationship, follower: bob, leader: alice)
        post :create, relationship: {leader_id: alice.id}
        expect(Relationship.count).to eq(1)
      end
    end
    it_behaves_like "requires sign in" do
      let(:action) { post :create, id: 4 }
    end
  end
end
