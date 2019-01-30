require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = User.first
    @assignment = Assignment.first
    @team = Team.first
    @scorecard = Scorecard.second
    @registration = Registration.first
    @joined_team_assignment = Assignment.find 11
    @joined_team = @team
    @invitee = User.third
    @invited_team_assignments = Assignment.find 12
    @invited_team = @team
    @judge = User.second
    @judge_assignment = Assignment.find 7
    @challenge = Challenge.first
    @leader_assignment = @joined_team_assignment
    @winning_entry = Entry.third
    @competition_registration = Registration.third
    @participating_event = Event.first
    @competition_event = Event.second
    @staff_assignment = @assignment
    @participant_assignment = Assignment.fourth
  end

  test 'user associations' do
    assert @user.assignments.include? @assignment
    assert @user.teams.include? @team
    assert @user.scorecards.include? @scorecard
    assert @user.registrations.include? @registration

    assert @user.joined_team_assignments.include? @joined_team_assignment
    assert @user.joined_teams.include? @joined_team

    assert @invitee.invited_team_assignments.include? @invited_team_assignments
    assert @invitee.invited_teams.include? @invited_team

    assert @judge.judge_assignments.include? @judge_assignment
    assert @judge.challenges_judging.include? @challenge

    assert @user.leader_assignments.include? @leader_assignment
    assert @user.leader_teams.include? @team
    assert @user.winning_entries.include? @winning_entry

    assert @user.participating_registrations.include? @competition_registration
    assert @user.participating_events.include? @participating_event
    assert @user.participating_competition_events.include? @competition_event

    assert @user.staff_assignments.include? @staff_assignment
    assert @user.staff_assignments.exclude? @participant_assignment

    @user.destroy
    assert_raises(ActiveRecord::RecordNotFound) { @assignment.reload }
  end

  test 'scopes' do
    assert User.search('one').include? @user
  end

  test 'user validations' do
    # no email don't save
    assert_not User.create(email: nil).save

    # no full name don't save
    assert_not User.create(preferred_name: nil).save
  end

  test 'admin_privileges' do
    # Does have.
    assert @user.admin_privileges?
    # Does not have.
    @assignment.destroy
    assert_not @user.admin_privileges?
  end

  test 'judge_assignment' do
    assert @judge.judge_assignment(@challenge) == @judge_assignment
    assert_nil @user.judge_assignment @challenge
  end
end
