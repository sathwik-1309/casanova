import './Listcard1.css'
import React from "react";
import Photocard from "../../Photocard/Photocard";

function LitscardItem(props){
    let player = props.player
    let pic_height = '0px'
    if (player.pos === 1){
        pic_height = '70px';
    }
    else {
        pic_height = '60px'
    }
    let content = <div className={`empty_pic ${player.color}1`}></div>
    if (player.pos === 1){
        content = <Photocard p_id = {player.p_id} color={player.color} height={pic_height}/>
    }


    return (
        <div className='lci'>
            {content}
                <div className={`lci__data ${player.color}1`}>
                    <div className='lci_row1'>
                        <div className='lci_name'>{player.name}</div>
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

function Listcard1(props){
    console.log(props)
    let player = props.data
    let pic_height = '0px'
    if (player.pos === 1){
        console.log("yes")
        pic_height = '70px';
    }
    else {
        console.log("no")
        pic_height = '60px'
    }
    const height_style = {
        height: pic_height
    };
    return(
        <div className='listcard_item'>
            <div style={height_style} className='listcard_item_sl_no'>{player.pos}</div>
            <LitscardItem player = {player}/>
        </div>
    );
}

export default Listcard1