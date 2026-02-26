import React from "react";
import './TournamentBox.css';
import {FRONTEND_API_URL} from "../../../../my_constants";
import Logo from "../../../../components/Team/Logo/Logo";

function TournamentBox(props) {
    let data = props.data
    return (
        <a className='tournament_box' href={`${FRONTEND_API_URL}/tournament/${data.t_id}`}>
            <div className='tournament_box_header'>{data.tour_class}</div>
            <div className={`tournament_box_winner`}>
                <div className='t_box_label'>🏆 WINNERS 🏆</div>
                <div className={`h-40 ${data.w_color}1`}>
                    <div className="flex-row h-40 flex-centered">
                        <Logo team={data.w_color} height={35}/>
                        <div className="h-40 font-0_9 font-600 flex-centered pl-10">{data.w_teamname}</div>
                    </div>
                    
                </div>
            </div>
            <div className='tournament_box_matches'>Matches: {data.matches}</div>
            <div className='tournament_box_pots'>POTS : {data.pots}</div>
        </a>
    );
}

export default TournamentBox
