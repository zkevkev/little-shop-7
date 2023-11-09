class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    
    if params[:update] == "status"
      invoice.update(status: params[:status].to_i)
      redirect_to admin_invoice_path(invoice.id)
    end
  end
end
