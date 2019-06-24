# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :authentificate
  add_flash_types :danger, :success

  private

  def authentificate
    redirect_to login_path unless logined?
  end
end
