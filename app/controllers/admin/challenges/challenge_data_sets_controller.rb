# frozen_string_literal: true

class Admin::Challenges::ChallengeDataSetsController < ApplicationController
  before_action :authenticate_user!, :check_for_privileges

  def new
    @challenge_data_set = @challenge.challenge_data_sets.new
    return if params[:term].blank?

    search_data_sets
  end

  def create
    @challenge_data_set = @challenge.challenge_data_sets.new(
      challenge_data_set_params
    )
    handle_create_save
  end

  def destroy
    @challenge_data_set = ChallengeDataSet.find params[:id]
    @challenge_data_set.destroy
    flash[:notice] = 'Challenge Data Set Destroyed'
    redirect_to admin_region_challenge_path @challenge.region, @challenge
  end

  private

  def challenge_data_set_params
    params.require(:challenge_data_set).permit :data_set_id
  end

  def check_for_privileges
    @challenge = Challenge.find params[:challenge_id]
    return if current_user.region_privileges? @challenge.competition

    flash[:alert] = 'You must have valid assignments to access this section.'
    redirect_to root_path
  end

  def handle_create_save
    if @challenge_data_set.save
      flash[:notice] = 'New Challenge Data Set Added'
      redirect_to admin_region_challenge_path(@challenge.region, @challenge)
    else
      flash[:alert] = @challenge_data_set.errors.full_messages.to_sentence
      render :new
    end
  end

  def search_data_sets
    @data_set = DataSet.find_by_url params[:term]
    if @data_set.present?
      @existing_challenge_data_set = ChallengeDataSet.find_by(
        data_set: @data_set, challenge: @challenge
      )
    else
      @data_sets = @competition.data_sets.search params[:term]
    end
  end
end
