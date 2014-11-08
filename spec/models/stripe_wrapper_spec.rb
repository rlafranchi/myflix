require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "charges card for valid card", :vcr do
        token = Stripe::Token.create(
          card: {
              number: "4242424242424242",
              exp_month: 12,
              exp_year: 2015,
              cvc: 123
            }
          ).id
        response = StripeWrapper::Charge.create(amount: 999, card: token, description: "a valid charge")
        expect(response).to be_successful
      end
      it "does not charge the card for invalid card", :vcr do
        token = Stripe::Token.create(
          card: {
              number: "4000000000000002",
              exp_month: 12,
              exp_year: 2015,
              cvc: 123
            }
          ).id
        response = StripeWrapper::Charge.create(amount: 999, card: token, description: "an invalid charge")
        expect(response).to_not be_successful
      end
      it "flashes error message for invalid card", :vcr do
        token = Stripe::Token.create(
          card: {
              number: "4000000000000002",
              exp_month: 12,
              exp_year: 2015,
              cvc: 123
            }
          ).id
        response = StripeWrapper::Charge.create(amount: 999, card: token, description: "an invalid charge")
        expect(response.error_message).to be_present
      end
    end
  end
end
