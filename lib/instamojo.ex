defmodule Instamojo do
  @moduledoc """
  Elixir bindings for Instamojo REST API.
  """

  @key :instamojo |> Application.fetch_env!(:key)
  @token :instamojo |> Application.fetch_env!(:token)

  @doc """
  Creates a payment request by `amount`, `purpose` and optional parameters.

  Optional parameters are:
  * `buyer_name`   : Name of payer(string)
  * `email`        : Email of payer(string)
  * `phone`        : Phone of payer(string)
  * `redirect_url` : URL where we redirect the user after a payment(String)
  * `webhook`      : URL where our server do POST request after a payment If provided, we will do a the POST request to the webhook (url) with full details of the payment(String)
  * `allow_repeated_payments`:	boolean
  * `send_email`   : boolean
  * `send_sms`     : boolean
  * `expires_at`   : Time after which the payment request will be expired. Max value is 600 seconds. Default is Null(datetime)
  
  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.create_request("10.00", "test1")                       
        {:ok,
          %{"payment_request" => %{"allow_repeated_payments" => false,
            "amount" => "10.00", "buyer_name" => nil,
            "created_at" => "2017-11-03T00:55:27.310825Z", "email" => nil,
            "email_status" => nil, "expires_at" => nil,
            "id" => "cf5a201bf7ad4bfdb7d5c2ef4b868ef6",
            "longurl" => "https://www.instamojo.com/@sasank92/cf5a201bf7ad4bfdb7d5c2ef4b868ef6",
            "modified_at" => "2017-11-03T00:55:27.310866Z", "phone" => nil,
            "purpose" => "test1", "redirect_url" => nil, "send_email" => false,
            "send_sms" => false, "shorturl" => nil, "sms_status" => nil,
            "status" => "Pending", "webhook" => nil}, "success" => true}}

  """
  def create_request(amount, purpose, options \\[]) do
    "https://www.instamojo.com/api/1.1/payment-requests/"
    |> HTTPoison.post({:form, ([amount: amount, purpose: purpose] ++ options)}, ["X-Api-Key": @key, "X-Auth-Token": @token])
    |> parse_response()
  end

  @doc """
  Retrieves list of payment requests created.

  Returns `{:ok, results}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.list_requests()
        {:ok,
          %{"payment_requests" => [%{"allow_repeated_payments" => false,
            "amount" => "10.00", "buyer_name" => nil,
            "created_at" => "2017-11-03T00:12:29.283733Z", "email" => nil,
            "email_status" => nil, "expires_at" => nil,
            "id" => "ebd9e382a0f3489ea0334ffdd141ccbe",
            "longurl" => "https://www.instamojo.com/@sasank92/ebd9e382a0f3489ea0334ffdd141ccbe",
            "modified_at" => "2017-11-03T00:15:20.621165Z", "phone" => nil,
            "purpose" => "test1", "redirect_url" => nil, "send_email" => false,
            "send_sms" => false, "shorturl" => "https://imjo.in/rcESzE",
            "sms_status" => nil, "status" => "Pending", "webhook" => nil},
          %{"allow_repeated_payments" => false, "amount" => "10.00",
            "buyer_name" => nil, "created_at" => "2017-11-02T22:40:00.571743Z",
            "email" => nil, "email_status" => nil, "expires_at" => nil,
            "id" => "116da8f4cac24431a67bd02ecce51b8b",
            "longurl" => "https://www.instamojo.com/@sasank92/116da8f4cac24431a67bd02ecce51b8b",
            "modified_at" => "2017-11-02T23:45:08.578178Z", "phone" => nil,
            "purpose" => "test", "redirect_url" => nil, "send_email" => false, 
            "send_sms" => false, "shorturl" => "https://imjo.in/fDr8qP",
            "sms_status" => nil, "status" => "Completed", "webhook" => nil}],
          "success" => true}}
  
  """
  def list_requests() do
    "https://www.instamojo.com/api/1.1/payment-requests/"
    |> HTTPoison.get(["X-Api-Key": @key, "X-Auth-Token": @token], [])
    |> parse_response()
  end

  @doc """
  Retrieves a payment request by `request_id`

  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.get_request("7817fa0100aa415b8d8be5e3fe825143")
        {:ok,
          %{"payment_request" => %{"allow_repeated_payments" => false,
            "amount" => "10.00", "buyer_name" => nil,
            "created_at" => "2017-11-02T23:05:13.979432Z", "email" => nil,
            "email_status" => nil, "expires_at" => nil,
            "id" => "7817fa0100aa415b8d8be5e3fe825143",
            "longurl" => "https://www.instamojo.com/@sasank92/7817fa0100aa415b8d8be5e3fe825143",
            "modified_at" => "2017-11-02T23:05:14.061533Z", "payments" => [],
            "phone" => nil, "purpose" => "test", "redirect_url" => nil,
            "send_email" => false, "send_sms" => false,
            "shorturl" => "https://imjo.in/byx5C5", "sms_status" => nil,
            "status" => "Pending", "webhook" => nil}, "success" => true}}

  """
  def get_request(request_id) do
    "https://www.instamojo.com/api/1.1/payment-requests/#{request_id}/"
    |> HTTPoison.get(["X-Api-Key": @key, "X-Auth-Token": @token], [])
    |> parse_response()
  end

  @doc """
  Creates a refund by `payment_id`, `type`, `body` and optional parameters.

  options are `:refund_amount`(string) - This field can be used to specify the refund amount. Default is paid amount.

  Valid  values for `type` parameter are:
  * `RFD`: Duplicate/delayed payment.
  * `TNR`: Product/service no longer available.
  * `QFL`: Customer not satisfied.
  * `QNR`: Product lost/damaged.
  * `EWN`: Digital download issue.
  * `TAN`: Event was canceled/changed.
  * `PTH`: Problem not described above.

  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.create_refund("MOJO7b03005A17255424", "QFL", "Testing")
        {:ok,
          %{"refund" => %{"body" => "Testing",
            "created_at" => "2017-11-03T00:57:08.174538Z", "id" => "C7b0389622",
            "payment_id" => "MOJO7b03005A17255424", "refund_amount" => "10.00",
            "status" => "Refunded", "total_amount" => "10.00", "type" => "QFL"},
          "success" => true}}

  """
  def create_refund(payment_id, type, body, options \\ []) do
    "https://www.instamojo.com/api/1.1/refunds/"
    |> HTTPoison.post({:form, ([payment_id: payment_id, type: type, body: body] ++ options)}, ["X-Api-Key": @key, "X-Auth-Token": @token])
    |> parse_response()
  end

  @doc """
  Retrieves list of refunds

  Returns `{:ok, results}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.list_refunds()                                     
        {:ok,
          %{"refunds" => [%{"body" => "Testing",
            "created_at" => "2017-11-03T00:02:18.522151Z", "id" => "C7b0316449",
            "payment_id" => "MOJO7b02005A92479648", "refund_amount" => "10.00",
            "status" => "Refunded", "total_amount" => "10.00", "type" => "QFL"}],
        "success" => true}}
  """
  def list_refunds() do
    "https://www.instamojo.com/api/1.1/refunds/"
    |> HTTPoison.get(["X-Api-Key": @key, "X-Auth-Token": @token], [])
    |> parse_response()
  end
  
  @doc """
  Retrieves a refund by `refund_id`

  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.get_refund("C7b0316449")
        {:ok,
          %{"refund" => %{"body" => "Testing",
            "created_at" => "2017-11-03T00:02:18.522151Z", "id" => "C7b0316449",
            "payment_id" => "MOJO7b02005A92479648", "refund_amount" => "10.00",
            "status" => "Refunded", "total_amount" => "10.00", "type" => "QFL"},
          "success" => true}}

  """
  def get_refund(refund_id) do
    "https://www.instamojo.com/api/1.1/refunds/#{refund_id}/"
    |> HTTPoison.get(["X-Api-Key": @key, "X-Auth-Token": @token], [])
    |> parse_response()
  end

  @doc """
  Retrieves payment detail by `payment_id`

  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.get_payment_details("MOJO7b02005A92479648")
        {:ok,
          %{"payment" => %{"affiliate_commission" => "0", "affiliate_id" => nil,
            "amount" => "10.00", "buyer_email" => "yadavallisasank@gmail.com",
            "buyer_name" => "Sasank", "buyer_phone" => "7995738307",
            "created_at" => "2017-11-02T23:44:18.790410Z", "currency" => "INR",
            "custom_fields" => %{}, "discount_amount_off" => nil,
            "discount_code" => nil, "failure" => nil, "fees" => "0.00",
            "instrument_type" => "CARD", "link_slug" => nil, "link_title" => nil,
            "payment_id" => "MOJO7b02005A92479648",
            "payment_request" => "https://www.instamojo.com/api/1.1/payment-requests/116da8f4cac24431a67bd02ecce51b8b/",
            "quantity" => 1, "shipping_address" => nil, "shipping_city" => nil,
            "shipping_country" => nil, "shipping_state" => nil, "shipping_zip" => nil,
            "status" => "Credit", "unit_price" => "10.00", "variants" => []},
          "success" => true}}

  """
  
  def get_payment_details(payment_id) do
    "https://www.instamojo.com/api/1.1/payments/#{payment_id}/"
    |> HTTPoison.get(["X-Api-Key": @key, "X-Auth-Token": @token], [])
    |> parse_response()
  end

  @doc """
  Enables a payment request by `request_id`

  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.enable_request("ebd9e382a0f3489ea0334ffdd141ccbe") 
        {:ok, %{"success" => true}}
  
  """
  def enable_request(request_id) do
    "https://www.instamojo.com/api/1.1/payment-requests/#{request_id}/enable/"
    |> HTTPoison.post({:form, []}, ["X-Api-Key": @key, "X-Auth-Token": @token])
    |> parse_response()
  end

  @doc """
  Disables a payment request by `request_id`

  Returns `{:ok, result}` on success, else `{:error, reason}`

  ## Example

        iex> Instamojo.disable_request("ebd9e382a0f3489ea0334ffdd141ccbe") 
        {:ok, %{"success" => true}}
  
  """
  def disable_request(id) do
    "https://www.instamojo.com/api/1.1/payment-requests/#{id}/disable/"
    |> HTTPoison.post({:form, []}, ["X-Api-Key": @key, "X-Auth-Token": @token])
    |> parse_response()
  end
  
  defp parse_response({:ok, %HTTPoison.Response{body: body, status_code: status}}) do
    case status do
      201 -> 
        Poison.decode(body)
      
      200 ->
        Poison.decode(body)
      
      400 ->
        reason = body |> Poison.decode!() |>get_in(["message"])

        {:error, reason}
      
      401 -> 
        reason = body |> Poison.decode!()

        {:error, reason}

      403 ->
        reason = body |> Poison.decode!()

        {:error, reason}

      301 ->
        {:error, "The API responded with a redirect request. You are most likely missing a trailing slash at the end of your request URL"}

      _ ->
        {:error, "Something's went wrong"}

    end
  end
end
