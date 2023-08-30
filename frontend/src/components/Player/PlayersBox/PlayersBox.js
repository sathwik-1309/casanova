import React from "react";
import Playerbox from "./PlayerBox/Playerbox";
import './PlayersBox.css'

function PlayersBox(props) {
    let data = props.data
    if ( data === null) {
        data = props.default
    }
    let label = ''
    switch (props.skill) {
        case "bat":
            label = "BATSMEN"
            break;
        case "wk":
            label = "WICKET-KEEPERS"
            break;
        case "all":
            label = "ALL-ROUNDERS"
            break;
        case "bow":
            label = "BOWLERS"
            break;
        default:
            break;
    }

    return (
        <div className='players_box_parent'>
            <div className='players_box_label default-font'>{label}</div>
            <div className='players_box'>
                {data[props.skill].map((player, index) => (
                    <Playerbox data={player}/>
                ))}
            </div>
        </div>
    );

}

export default PlayersBox
