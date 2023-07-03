import Photocard from "../../Photocard/Photocard";
import React from "react";
import './UpcomingMatch.css'

function UpcomingMatch(props) {
    const match = props.match
    return (
        <div className='upcoming_match default-font'>
            <div className='um_header'>
                <div className='um_tourname'>{match.tourname}</div>
                <div className='um_venue'>{match.venue}</div>
            </div>
            <div className='um_teams'>
                <div className='um_team'>
                    <div className='um_captain_pic'>
                        <div className={`um_empty ${match.team1.color}1`}></div>
                        <Photocard p_id = {match.team1.captain_id} color={match.team1.color} height={'100px'}/>
                        <div className={`um_empty ${match.team1.color}1`}></div>
                    </div>
                    <div className={`um_teamname ${match.team1.color}1`}>{match.team1.teamname}</div>
                </div>
                <div className='um_team'>
                    <div className='um_captain_pic'>
                        <div className={`um_empty ${match.team2.color}1`}></div>
                        <Photocard p_id = {match.team2.captain_id} color={match.team2.color} height={'100px'}/>
                        <div className={`um_empty ${match.team2.color}1`}></div>
                    </div>
                    <div className={`um_teamname ${match.team2.color}1`}>{match.team2.teamname}</div>
                </div>
            </div>
        </div>
    );
}

export default UpcomingMatch;
