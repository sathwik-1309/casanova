class SpellController < ApplicationController
  def spell
    hash = {}
    spell = Spell.find(params[:id])
    hash['spell_box'] = spell.spell_box
    overs = spell.get_overs
    hash['phase_box'] = spell.phase_box(overs)
    balls = Ball.where(bowler_id: spell.player_id, inning_id: spell.inning_id)
    hash['vs_batsmen'] = spell.vs_batsmen(balls)
    render(:json => Oj.dump(hash))
  end
end
