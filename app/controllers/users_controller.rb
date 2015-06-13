class UsersController < ApplicationController
  def index
    @user = User.find(session[:user_id])

    @calendars = Calendar.all
    @events_by_date = Calendar.pluck(:date, :title, :description)
    @date = params[:date] ? Date.parse(params[:date]) : Date.today

    @events_by_date_mini = @calendars.group_by(&:date)
  end
end
