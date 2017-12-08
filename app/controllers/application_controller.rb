class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected def currentDateTime
    @systemDate = DateTime.now
    return @systemDate
  end
end
