import Photocard from "../Photocard/Photocard";
import React from "react";
import './PlayerCard.css'
import {useParams} from "react-router-dom";
import kkr from './../../../assets/logos/kkr.png'
import srh from './../../../assets/logos/srh.png'
import mi from './../../../assets/logos/mi.png'
import rcb from './../../../assets/logos/rcb.png'
import Logo from "../../Team/Logo/Logo";

function PlayerCard(props){
    let { t_id } = useParams();
    let player = props.player
    let content = <div></div>
    let pic_height = '0px'
    if (props.pic) {
        pic_height = '80px';
        content = <Photocard p_id = {player.p_id} color={player.color} height={pic_height} padding='10%'/>
    }

    return (
        <div className='lci'>
            {content}
            <div className={`lci__data`} onClick={() => props.func(player.p_id)}>
                <div className='lci_row1 h-40 font-1'>
                    <div className={`lci_name font-600 flex vert-align lp-20 ${player.color}1`}>{player.name}</div>
                    <div className={`lci_data1 font-1_1 flex-centered ${player.color}2`}>{player.data1}</div>
                </div>
                <div className={`lci_row2 h-40 ${player.color}1`}>
                    <div className='flex-row w-180 pl-15'>
                        <Logo team={player.color} height={25}/>
                        <div className="h-40 flex-centered pl-8">{player.teamname}</div>
                    </div>
                    <div className='lci_data2 flex-centered'>{player.data2}</div>
                </div>
            </div>
        </div>
    );
}

export default PlayerCard
