require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      token = Stripe::Token.create(
        card: {
            number: "4242424242424242",
            exp_month: 12,
            exp_year: 2015,
            cvc: 123
          }
        ).id
      response = StripeWrapper::Charge.create(amount: 999, card: token, description: "a valid charge")
      expect(response.amount).to eq(999)
      expect(response.currency).to eq("usd")
    end
  end
end
