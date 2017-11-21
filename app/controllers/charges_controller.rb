class ChargesController < ApplicationController
  def simple
    @simple_charge = PaymentsConnection.new.simple_charge(params)
  end
end
