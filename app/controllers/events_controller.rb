class EventsController < ApplicationController
  before_action :set_event, except: [:index, :new]
  before_action :set_user, only: [:index]
  def index
  end
  def show; end
  def new
    if current_user.id == 1
      Event.create!(
               user_id: current_user.id,
               from_user_id: 3,
               serialized_subject: {class_name: "Job", id: 806},
               readed: false,
               comment: "Hello From ws",
               event_type: 1
      )
    end
  end
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

