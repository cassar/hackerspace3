# frozen_string_literal: true

class Admin::EventPartnershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_for_privileges_from_event!, except: :destroy
  before_action :check_for_privileges_from_sponsor!, only: :destroy

  def new
    @event_partnership = EventPartnership.new
    return if params[:term].blank?

    @sponsor = @competition.sponsors.find_by_name params[:term]
    @sponsors = @competition.sponsors.search(params[:term]) unless @sponsor.present?
  end

  def create
    @event_partnership = EventPartnership.new event_partnership_params
    @event_partnership.event = @event
    if @event_partnership.save
      flash[:notice] = 'New Event Partner Added.'
      redirect_to admin_region_event_path @event.region, @event
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      render :new
    end
  end

  def destroy
    @event_partnership.destroy
    flash[:notice] = 'Event Partnership Destroyed'
    redirect_to admin_competition_sponsor_path @competition, @sponsor
  end

  private

  def event_partnership_params
    params.require(:event_partnership).permit :sponsor_id
  end

  def check_for_privileges_from_event!
    @event = Event.find params[:event_id]
    @competition = @event.competition
    check_for_redirect
  end

  def check_for_privileges_from_sponsor!
    @event_partnership = EventPartnership.find params[:id]
    @sponsor = @event_partnership.sponsor
    @competition = @sponsor.competition
    check_for_redirect
  end

  def check_for_redirect
    return if current_user.admin_privileges? @competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end
end
