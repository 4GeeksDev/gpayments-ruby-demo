class PaymentsConnection
  attr_accessor :client_id, :client_secret, :base_url, :token

  def initialize
    @client_id = ENV["client_id"]
    @client_secret = ENV["client_secret"]
    @base_url = ENV["base_url"]
    @token = generate_token
  end

  def generate_token
    response =  RestClient.post "#{base_url}/authentication/token/",
                                auth_params,
                                { content_type: 'application/json' }
    JSON.parse(response.body)['access_token']
  end

  def simple_charge(params)
    begin
      response = RestClient.post "#{base_url}/v1/charges/simple/create/",
                                charge_params(params),
                                auth_header
      { code: response.code, body: JSON.parse(response.body) }
    rescue => e
      { code: 400, body: JSON.parse(e.response)['detail'] }
    end
  end

  private

  def charge_params(params)
    {
      amount: params[:amount], description: "Ruby Test",
      entity_description: "Ruby for Bank",
      currency: "USD", credit_card_number: params[:number],
      credit_card_security_code_number: params[:cvc],
      exp_month: expiry_mont(params[:expiry]), exp_year: expiry_year(params[:expiry])
    }
  end

  def auth_header
    { Authorization: "Bearer #{token}", content_type: 'application/json' }
  end

  def auth_params
    {
      grant_type: 'client_credentials', client_id: client_id,
      client_secret: client_secret
    }.to_json
  end

  def expiry_mont(expiry)
    expiry.split('/').first
  end

  def expiry_year(expiry)
    expiry.split('/').second
  end
end
