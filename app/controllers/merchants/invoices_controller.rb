class Merchants::InvoicesController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def show
    @invoice = Invoice.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
    @customer = @invoice.customer
  end

  def update
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice.update(invoice_params)
    
    redirect_to merchant_invoice_path(@merchant, @invoice)
  end

  private
  
  def invoice_params
    params.require(:invoice).permit(:status)
  end
end