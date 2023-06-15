class VenueController < ApplicationController
  def venues
    array = []

    if params[:tour_class]
      matches = Match.where(tournament_id: (Tournament.where(name: params[:tour_class])).pluck(:id))
    else
      matches = Match.all
    end
    venues = matches.distinct.order(:venue).pluck(:venue)

    venues.each do|venue|
      temp = {}
      venue_matches = matches.where(venue: venue)
      break if venue_matches == []
      inn = Inning.where(inn_no: 1).where(match_id: venue_matches.pluck(:id))
      inn_runs = inn.pluck(:score)
      inn_wickets = inn.pluck(:for)
      temp["venue"] = venue.upcase
      temp["matches"] = venue_matches.count
      temp["chased"] = venue_matches.where("win_by_wickets > 0").count
      temp["defended"] = venue_matches.where("win_by_runs > 0").count
      avg_score = inn_runs.sum / inn_runs.size.to_f
      temp["avg_score"] = avg_score.round(1)
      temp["avg_wickets"] = (inn_wickets.sum / inn_wickets.size.to_f).round(1)
      array << temp
    end
    render(:json => Oj.dump(array))
  end
end
