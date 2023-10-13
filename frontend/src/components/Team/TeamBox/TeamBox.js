import React, {useEffect, useState} from 'react';
import './TeamBox.css'
import ProgressBar from "../../ProgressBar/ProgressBar";
import {team_colors} from "../../Match/Graph/team_colors";
import { Link } from 'react-router-dom';
import { FRONTEND_API_URL } from '../../../my_constants';
import TeamWinPercentage from '../TeamWinPercentage/TeamWinPercentage';

function TeamBox(props) {
    let data = props.data
    const meta = {
        color: data.color
    }
    data.total_matches = data.played
    return (
        <Link className= 'teambox_parent' to={`${FRONTEND_API_URL}/teams/${data.id}`}>
            <div className={`teambox`}>
                <div className={`teambox_trophies `}>{data.trophies}</div>
                <div className={`teambox_teamname ${data.color}1`}>{data.teamname}</div>
                {
                    data.is_team ? <div className={`teambox_tournaments ${data.color}1`}>Tournaments: {data.squads}</div> 
                    :
                    <div className={`teambox_tournaments ${data.color}1`}>Players: {data.players}</div>
                }
                
                {/* <div className={`teambox_tournaments ${data.color}1`}>Won: {data.won} / {data.played}</div> */}
                {/*<div className={`teambox_tournaments`}>Win_p: {data.win_p} %</div>*/}
                {/* <div className='flex-col'> */}
                    {/* <div className='h-30 flex-centered font-500 font-0_9'>WIN %</div> */}
                    {/* <div className='flex-centered progress-container'>
                        <ProgressBar progress={data.win_p} label={`${data.win_p} %`} color1={`${analysis1}`} color2={`${analysis2}`} width='200' height='30'/>
                    </div> */}
                    <TeamWinPercentage meta={meta} data={data} width='w-240' bg='bg-white'/>
                {/* </div> */}
            </div>
        </Link>
    );
}
export default TeamBox;
