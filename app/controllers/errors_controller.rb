class ErrorsController < ApplicationController

  def routing_error(error = 'Routing error', status = :not_found, exception=nil)
    render 'errors/not_found'
  end

end
