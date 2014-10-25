module StripeWrapper
  class Charge
    def self.create(options={})
      Stripe::Charge.create(
        card: options[:card],
        amount: options[:amount],
        currency: "usd",
        description: options[:description]
      )
    end
  end
end
