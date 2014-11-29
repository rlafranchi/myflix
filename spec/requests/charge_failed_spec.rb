require 'spec_helper'

describe "failed payment" do
  let(:event_data) do
    {
      "id"=> "evt_153yKmEanUtDmyIAjUe8enTa",
      "created"=> 1417217972,
      "livemode"=> false,
      "type"=> "charge.failed",
      "data"=> {
        "object"=> {
          "id"=> "ch_153yKmEanUtDmyIArhA9qGKU",
          "object"=> "charge",
          "created"=> 1417217972,
          "livemode"=> false,
          "paid"=> false,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "captured"=> false,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_153yKmEanUtDmyIArhA9qGKU/refunds",
            "data"=> []
          },
          "card"=> {
            "id"=> "card_153yJUEanUtDmyIAJZ8YN77a",
            "object"=> "card",
            "last4"=> "0341",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 12,
            "exp_year"=> 2015,
            "fingerprint"=> "EmzWS59NgmOhIwn8",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "dynamic_last4"=> nil,
            "customer"=> "cus_5EQ4eraGefxegG"
          },
          "balance_transaction"=> nil,
          "failure_message"=> "Your card was declined.",
          "failure_code"=> "card_declined",
          "amount_refunded"=> 0,
          "customer"=> "cus_5EQ4eraGefxegG",
          "invoice"=> nil,
          "description"=> "test fail",
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> "test fail",
          "fraud_details"=> {
            "stripe_report"=> "unavailable",
            "user_report"=> nil
          },
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_5ERDRTW1FtXEIh",
      "api_version"=> "2014-10-07"
    }
  end
  it "does not create a payment", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5EQ4eraGefxegG")
    post '/stripe_events', event_data
    expect(Payment.count).to eq(0)
  end
  it "locks user out of account", :vcr do
    alice = Fabricate(:user, customer_token: "cus_5EQ4eraGefxegG")
    post '/stripe_events', event_data
    expect(alice.reload).to_not be_active
  end
end
