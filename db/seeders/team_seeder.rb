require_relative 'seeder'

class TeamSeeder < Seeder
  def self.create(event, competition, participant_assignments, challenges)
    events = competition.events.competitions
    assignment_ids = Registration.where(event: events).pluck :assignment_id
    user_ids = Assignment.where(id: assignment_ids).pluck :user_id
    competitionetitors = User.where id: user_ids

    return unless competitionetitors.any?

    [*0..10].sample.times do |team_time|
      team = event.teams.create

      team.assign_leader(competitionetitors.sample)
      [*1..8].sample.times do
        user = competitionetitors.sample
        team.assignments.team_members.create(
          user: user,
          holder: user.holder_for(competition)
        )
      end
      [*0..2].sample.times do
        user = competitionetitors.sample
        team.assignments.team_invitees.create(
          user: user,
          holder: user.holder_for(competition)
        )
      end

      [*1..3].sample.times do |time|
        team.projects.create(
          team_name: "#{event.name} team #{team_time} #{competition.year}",
          description: Faker::Lorem.paragraph,
          tag_list: random_tags,
          project_name: "#{event.name} project #{team_time}",
          data_story: Faker::Lorem.paragraph,
          source_code_url: 'https://github.com/tenderlove/allocation_sampler',
          video_url: 'https://www.youtube.com/embed/-aOYRiY7Avk',
          homepage_url: 'https://www.govhack.org/',
          user: team.leaders.first
        )
      end

      [*0..3].sample.times do |time|
        team.team_data_sets.create(
          name: "#{team.name} dataset #{team_time + time} #{competition.year}",
          description: Faker::Lorem.paragraph,
          description_of_use: Faker::Lorem.paragraph,
          url: "https://data.gov.au/dataset/#{Faker::Movies::LordOfTheRings.character}"
        )
      end

      return unless challenges.any?

      competition.checkpoints.each_with_index do |checkpoint, index|
        entry = team.entries.create(
          checkpoint: checkpoint,
          challenge: challenges.sample,
          justification: Faker::Lorem.paragraph,
          award: (AWARD_NAMES + Array.new(8) {nil}).sample
        )

        next unless entry.persisted?

        competition.competition_assignments.judges.where(
          assignable_type: 'Challenge',
          assignable_id: entry.challenge_id
        ).each do |assignment|
          header = Header.create(
            scoreable: entry,
            assignment: assignment,
            included: (assignment.id % 5 != 0)
          )
          competition.challenge_criteria.each do |criterion|
            score = Random.rand(11)
            score = nil if score.zero?
            Score.create(
              criterion: criterion,
              header: header,
              entry: score
            )
          end
        end
      end

      return unless participant_assignments.any?

      [*0..5].sample.times do
        assignment = participant_assignments.sample
        header = Header.create(
          scoreable: team,
          assignment: assignment,
          included: (assignment.id % 5 != 0)
        )
        competition.project_criteria.each do |criterion|
          score = Random.rand(11)
          score = nil if score.zero?
          Score.create(
            criterion: criterion,
            header: header,
            entry: score
          )
        end
      end
    end
  end
end
