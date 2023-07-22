import './Listcard1.css'
import React from "react";
import PlayerCard from "../../Player/PlayerCard/PlayerCard";

function Listcard1(props){
    let player = props.data
    let pic_height = '0px'
    let pic = true
    if (player.pos === 1){
        pic_height = '70px';
    }
    else {
        pic_height = '60px'
        pic = false
    }
    const height_style = {
        height: pic_height
    };
    return(
        <div className='listcard_item'>
            <div style={height_style} className='listcard_item_sl_no'>{player.pos}</div>
            <PlayerCard player = {player} pic={pic} func={props.func}/>
        </div>
    );
}

export default Listcard1
