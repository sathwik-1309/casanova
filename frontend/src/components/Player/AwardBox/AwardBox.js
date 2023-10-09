import Photocard from "../Photocard/Photocard";
import React from "react";
import './AwardBox.css'

function AwardBox(props){
    let player = props.player
    const pic_height = '70px';
    if (!player) return
    let content = <Photocard p_id = {player.p_id} color={player.color} height={pic_height}/>
    let logo = ''
    switch (props.award) {
        case "pots":
            logo = '👑'
            break;
        case "mvp":
            logo = '🎖'
            break;
        case "most_runs":
            logo = '🏏'
            break;
        case "most_wickets":
            logo = '🏏'
            break;
        case "gem":
            logo = '💎'
            break;
    }

    return (
        <div className='award_box'>
            {content}
            <div className={`award_box_data ${player.color}1`}>
                <div className='ab_row1'>
                    <div className='ab_name'>{player.name}</div>
                    <div className={`ab_teamname ${player.color}1`}>{player.teamname}</div>
                </div>
                <div className='ab_row2'>
                    <div className='ab_info'>{player.data}</div>
                    <div className={`ab_logo ${player.color}2`}>{logo}</div>
                </div>
            </div>
        </div>
    );
}

export default AwardBox
