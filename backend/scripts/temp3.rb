perf = Performance.where(tournament_id: Tournament.wt20_ids)

a = []
perf.each do |p|
  unless p.rank_bat_after.nil?
    if p.rank_bat_before.nil?
      diff = 51 - p.rank_bat_after
    else
      diff = p.rank_bat_before - p.rank_bat_after
    end
    a << [diff, p.player.name, p.match_id]
  end
  
  
end

a = a.sort_by{|p| -p[0]}
print a[0..5]