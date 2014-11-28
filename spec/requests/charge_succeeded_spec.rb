require 'spec_helper'

describe 'charge succeeded' do
  let(:event_data) {
    {
      "id"=> "evt_153vdIEanUtDmyIA5qsYCawx",
      "created"=> 1417207588,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_153vdIEanUtDmyIAj5g2HavP",
          "object"=> "charge",
          "created"=> 1417207588,
          "livemode"=> false,
          "paid"=> true,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "captured"=> true,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_153vdIEanUtDmyIAj5g2HavP/refunds",
            "data"=> []
          },
          "card"=> {
            "id"=> "card_153vdGEanUtDmyIAzU3g3vk0",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 12,
            "exp_year"=> 2014,
            "fingerprint"=> "IDIL0AA2hjQ2FK2e",
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
            "customer"=> "cus_5EOQXcrSo4lxKk"
          },
          "balance_transaction"=> "txn_153vdIEanUtDmyIAe9DK7uFa",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_5EOQXcrSo4lxKk",
          "invoice"=> "in_153vdIEanUtDmyIA1mYtwU8Y",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {},
          "statement_description"=> "Basic Myflix",
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
      "request"=> "iar_5EOQqXO1A3aAYI",
      "api_version"=> "2014-10-07"
    }
  }
  it "creates a Payment", :vcr do
    post '/stripe_events', event_data
    expect(Payment.count).to eq(1)
  end
  it "associates payment with user", :vcr do
    bob =Fabricate(:user, customer_token: "cus_5EOQXcrSo4lxKk")
    post '/stripe_events', event_data
    expect(Payment.first.user).to eq(bob)
  end
  it "creates the amount for the Payment", :vcr do
    bob =Fabricate(:user, customer_token: "cus_5EOQXcrSo4lxKk")
    post '/stripe_events', event_data
    expect(Payment.first.amount).to eq(999)
  end
  it "stores the reference id", :vcr do
    bob =Fabricate(:user, customer_token: "cus_5EOQXcrSo4lxKk")
    post '/stripe_events', event_data
    expect(Payment.first.reference_id).to eq("ch_153vdIEanUtDmyIAj5g2HavP")
  end
end
