class Schedule < ApplicationRecord
  belongs_to :tournament

  def squad1
    Squad.find_by_id(self.squad1_id)
  end
  def squad2
    Squad.find_by_id(self.squad2_id)
  end

  def match
    Match.find_by_id(self.match_id)
  end

  def self.create_tournament_schedules(json)
    t_id = json['t_id']
    default_stage = json['default_stage']
    matches = json['matches']
    order = 1
    matches.each do |match|
      s = Schedule.new
      squad1 = Squad.find_by(abbrevation: match['team1'], tournament_id: t_id)
      squad2 = Squad.find_by(abbrevation: match['team2'], tournament_id: t_id)
      s.squad1_id = squad1.id
      s.squad2_id = squad2.id
      s.venue = match['venue']
      s.stage = match['stage'].present? ? match['stage'] : default_stage
      s.completed = false
      s.order = order
      s.tournament_id = t_id
      order += 1
      s.save!
    end
  end

  def match
    Match.find_by_id(self.match_id)
  end

end
