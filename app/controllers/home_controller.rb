class HomeController < ApplicationController
  skip_before_action :logged_in_user
  before_action :forbid_login_user
  def top
  end
end
