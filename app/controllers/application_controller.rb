class ApplicationController < ActionController::Base
  # Pagy pagination methods for controllers.
  include Pagy::Method
end