class ScorecardsController < ApplicationController
  before_action :authenticate_user!

  def new
    @user = current_user
    @project = Project.find_by(identifier: params[:project_identifier])
    @team = @project.team
    @event_assignment = current_user.event_assignment
    @scorecard = @team.scorecards.create(assignment: @event_assignment)
    @judgments = organise_judgments
  end

  def edit
    @user = current_user
    @project = Project.find_by(identifier: params[:project_identifier])
    @team = @project.team
    @scorecard = Scorecard.find(params[:id])
    @judgments = organise_judgments
    @team = @scorecard.judgeable
  end

  def update
    retrieve_update_vars
    if process_judgments
      flash[:notice] = 'Scorecard Saved'
      redirect_to project_path(@team.current_project.identifier)
    else
      flash[:alert] = 'Error: One or more scores missing or out of range'
      render :new
    end
  end

  private

  def retrieve_update_vars
    @user = current_user
    @scorecard = Scorecard.find(params[:id])
    @team = @scorecard.judgeable
    @project = @team.current_project
    @judgments = organise_judgments
  end

  def process_judgments
    success = true
    @judgments.each do |judgment|
      new_score = params[:judgments][judgment.id.to_s][:score].to_i
      if validate_new_score(new_score)
        judgment.update(score: new_score)
      else
        success = false
      end
    end
    success
  end

  def validate_new_score(new_score)
    return false if new_score.blank?
    return false unless (MIN_SCORE..MAX_SCORE).cover?(new_score)
    true
  end

  def organise_judgments
    @scorecard.update_judgments
    assignments = Assignment.where(user: @user, title: JUDGE, assignable: @team.challenges)
    all_judgments = @scorecard.judgments.to_a
    return all_judgments unless assignments.present?
    assignments.each { |assignment| all_judgments += organise_challenge_scorecard(assignment) }
    all_judgments
  end


  def organise_challenge_scorecard(assignment)
    entry = Entry.find_by(team: @team, challenge: assignment.assignable)
    scorecard = Scorecard.find_or_create_by(assignment: assignment, judgeable: entry)
    scorecard.update_judgments
    scorecard.judgments.to_a
  end
end
