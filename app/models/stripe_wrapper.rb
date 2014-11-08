module StripeWrapper
  class Charge
    attr_reader :response, :error_message
    def initialize(response, error_message)
      @response = response
      @error_message = error_message
    end
    def self.create(options={})
      begin
        response = Stripe::Charge.create(
          card: options[:card],
          amount: options[:amount],
          currency: "usd",
          description: options[:description]
        )
        new(response, nil)
      rescue Stripe::CardError => e
        new(nil, e.message)
      end
    end
    def successful?
      @response.present?
    end
    def error_message
      @error_message
    end
  end
end
