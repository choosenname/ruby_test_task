class EventsController < ApplicationController
  before_action :require_login
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
    @events = current_user.events.includes(:category)
    @events = @events.where("name ILIKE ?", "%#{params[:search_name]}%") if params[:search_name].present?
    @events = @events.where(category_id: params[:search_category]) if params[:search_category].present? && params[:search_category] != "0"
    @events = @events.paginate(page: params[:page], per_page: 20)
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
    @weather_info = fetch_weather_info(@event.date)
  end

  def edit
    if @event.date.past?
      redirect_to events_path, alert: 'You cannot edit past events.'
    end
  end

  def update
    if @event.date.past?
      redirect_to events_path, alert: 'You cannot update past events.'
    elsif @event.update(event_params)
      redirect_to event_path(@event), notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @event.date.past?
      redirect_to events_path, alert: 'You cannot delete past events.'
    else
      @event.destroy
      redirect_to events_path, notice: 'Event was successfully destroyed.'
    end
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

  def set_event
    @event = current_user.events.find(params[:id])
  end

  def fetch_weather_info(date)
    response = HTTParty.get("https://api.getambee.com/weather",
                            query: {
                              "api_key": "ee18f3e4f5a08d168a0e02f5795d34d0d0e315fa5b1fe368c1217fc9638d7669",
                              "lat": "40.7128",
                              "lng": "-74.0060",
                              "date": date.to_s
                            })

    if response.success?
      weather_data = JSON.parse(response.body)
      return weather_data["weather"]
    else
      return { "message" => "Information is not available" }
    end
  end
end
