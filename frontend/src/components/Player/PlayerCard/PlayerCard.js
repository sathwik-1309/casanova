import Photocard from "../../Photocard/Photocard";
import React from "react";
import './PlayerCard.css'

function PlayerCard(props){
    console.log(props)
    let player = props.player
    let content = <div className={`empty_pic ${player.color}1`}></div>
    let pic_height = '0px'
    if (props.pic) {
        pic_height = '70px';
        content = <Photocard p_id = {player.p_id} color={player.color} height={pic_height}/>
    }
    else {
        pic_height = '60px'
    }

    return (
        <div className='lci'>
            {content}
            <div className={`lci__data ${player.color}1`}>
                <div className='lci_row1'>
                    <div className='lci_name font-600 font-1'>{player.name}</div>
                    <div className={`lci_data1 ${player.color}2`}>{player.data1}</div>
                </div>
                <div className='lci_row2'>
                    <div className='lci_teamname'>{player.teamname}</div>
                    <div className='lci_data2'>{player.data2}</div>
                </div>
            </div>
        </div>
    );
}

export default PlayerCard
