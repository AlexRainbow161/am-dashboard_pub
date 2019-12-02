class EventsBroadcastJob < ApplicationJob
  queue_as :default

  def perform(event)
    ActionCable.server.broadcast "events_#{event.user.id}", {message: render_event(event), event_count: event.user.events.unreaded.count}
  end
  private
  def render_event(event)
    EventsController.render(
                        partial: "event_#{event.subject.class.to_s.downcase}_#{event.event_type}",
                        locals: {event: event, context: "dropdown"})
  end
end
