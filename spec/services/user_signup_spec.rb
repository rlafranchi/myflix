require 'spec_helper'

describe UserSignup do
  describe "#sign_up" do
    context "with valid user info and valid card" do
      let(:customer) { double(:customer, successful?: true) }
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      it "should create the user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_token", nil)
        expect(User.count).to eq(1)
      end
      it "creates relationships between inviter and invitee with valid token" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, user_id: inviter.id)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_token", invitation.token)
        expect(Relationship.count).to eq(2)
      end
      it "does not create relationship for invalid token" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_token", "bad_token")
        expect(Relationship.count).to eq(0)
      end
      it "expires invitation token upon creation" do
        inviter = Fabricate(:user)
        invitation = Fabricate(:invitation, user_id: inviter.id)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_token", invitation.token)
        expect(invitation.reload.token).to be_nil
      end
    end
    context "with valid user info and declined card" do
      let(:customer) { double(:customer, successful?: false, error_message: 'Your card was declined.') }
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user)).sign_up("some_token", nil)
      end
      it "does not create user" do
        expect(User.count).to eq(0)
      end
    end
    context "with invalid user info input and valid card" do
      let(:customer) { double(:customer, successful?: true) }
      before do
        UserSignup.new(Fabricate.build(:user, email: "", password: "password", name: "Name")).sign_up("some_token", nil)
      end
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      it "does not charge card" do
        StripeWrapper::Customer.should_not_receive(:create)
      end
    end
    context "email sending" do
      context "valid input" do
        let(:customer) { double(:customer, successful?: true) }
        after { ActionMailer::Base.deliveries.clear }
        before do
          StripeWrapper::Customer.should_receive(:create).and_return(customer)
          UserSignup.new(Fabricate.build(:user)).sign_up("some_token", nil)
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
      context "invalid input" do
        it "does not send an email" do
          UserSignup.new(Fabricate.build(:user, email: "", password: "password", name: "Name")).sign_up("some_token", nil)
          ActionMailer::Base.deliveries.should be_empty
        end
      end
    end
  end
end
