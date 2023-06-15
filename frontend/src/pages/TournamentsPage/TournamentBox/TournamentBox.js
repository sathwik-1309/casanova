import React from "react";
import './TournamentBox.css'

function TournamentBox(props) {
    let data = props.data
    return (
        <div className='tournament_box'>
            <div className='tournament_box_header'>{data.tour_class}</div>
            <div className={`tournament_box_winner`}>
                <div className='t_box_label'>🏆 WINNERS 🏆</div>
                <div className={`t_box_teamname ${data.w_color}1`}>{data.w_teamname}</div>
            </div>
            <div className='tournament_box_matches'>Matches: {data.matches}</div>
            <div className='tournament_box_pots'>POTS : {data.pots}</div>
        </div>
    );
}

export default TournamentBox
