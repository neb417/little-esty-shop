class Admin::DashboardController < ApplicationController

  def index
    @top_customers = Customer.top_customers
    @invoices = Invoice.all
    @incomplete_invoices = @invoices.incomplete_invoices
  end


end
