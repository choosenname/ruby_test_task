class EventsController < ApplicationController
  before_action :require_login

  def index
    @events = current_user.events
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.build(event_params)
    if @event.save
      redirect_to events_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  def show
    @event = current_user.events.find(params[:id])
  end

  def edit
    @event = current_user.events.find(params[:id])
  end

  def update
    @event = current_user.events.find(params[:id])
    if @event.update(event_params)
      redirect_to event_path(@event), notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @event = current_user.events.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: 'Event was successfully destroyed.'
  end

  private

  def event_params
    params.require(:event).permit(:name, :date, :description, :category_id)
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: 'You must be logged in to perform this action.'
    end
  end
end
