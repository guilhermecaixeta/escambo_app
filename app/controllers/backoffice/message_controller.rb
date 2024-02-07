class Backoffice::MessageController < ApplicationController
  def new
    @admin = Admin.find(params[:message_id])

    respond_to do |format|
      format.js
    end
  end

  def create
    #
  end
end
