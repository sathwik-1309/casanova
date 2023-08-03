import './PerformanceBox.css'
import React from "react";
import Scorebox from "../Scorebox/Scorebox";
import SpellBox from "../SpellBox/SpellBox";

function PerformanceBox(props) {
    let boxes = props.data

    if (boxes.type === 'score') {
        return (
            <Scorebox data={boxes} func={props.func}/>
        );
    }
    else if (boxes.type === 'spell') {
        return (
            <SpellBox data={boxes} func={props.func}/>
        );
    }

}
export default PerformanceBox;
