class EventsController < ApplicationController
  before_action :set_event, except: [:index]
  before_action :set_user, only: [:index]
  def index; end
  def show; end
  def new; end
  def create; end
  def update
    @event.update(event_params)
    respond_to do |format|
      format.js
    end
  end
  def destroy; end

  private

  def event_params
    params.require(:event).permit(:readed)
  end
  def set_event
    @event = Event.find(params[:id])
  end
  def set_user
    if current_user.admin?
      @user = User.find(params[:user_id])
    else
      @user = current_user
    end

  end
end
