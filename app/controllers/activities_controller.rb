class ActivitiesController < ApplicationController
  RECENT_COUNT = 20

  def index
    @activities = Activity.recent(RECENT_COUNT)
  end
end
