import React, {useEffect, useState} from 'react';
import './TeamBox.css'
import ProgressBar from "../../ProgressBar/ProgressBar";
import {team_colors} from "../../Graph/team_colors";
function TeamBox(props) {
    let data = props.data
    const analysis1 = team_colors.analysis1
    const analysis2 = team_colors.analysis2
    return (
        <div className= 'teambox_parent'>
            <div className={`teambox`}>
                <div className={`teambox_trophies bg-white`}>{data.trophies}</div>
                <div className={`teambox_teamname ${data.color}1`}>{data.teamname}</div>
                <div className={`teambox_tournaments ${data.color}1`}>Tournaments: {data.squads}</div>
                <div className={`teambox_tournaments ${data.color}1`}>Won: {data.won} / {data.played}</div>
                {/*<div className={`teambox_tournaments`}>Win_p: {data.win_p} %</div>*/}
                <div className='flex-col'>
                    <div className='h-30 flex-centered font-500 font-0_9'>WIN %</div>
                    <div className='flex-centered'>
                        <ProgressBar progress={data.win_p} label={`${data.win_p} %`} color1={`${analysis1}`} color2={`${analysis2}`} width='200' height='30'/>
                    </div>
                </div>
            </div>
        </div>
    );
}
export default TeamBox;
