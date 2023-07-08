import './MilestoneBox.css'
import React, {useEffect, useState} from "react";

function Milestone(props) {
    let data = props.data
    let [selected, setSelected] = useState(false);
    let previous_message = <></>
    const set_selected = () => {
        setSelected(!selected);
    };
    if (selected === true) {
        previous_message = <div className='milestone_previous'>
            {data.previous}
        </div>
    }
    return (
        <div className='milestone_parent'>
            <div className={`milestone ${data.color}1`} onClick={set_selected}>
                {data.message}
            </div>
            {previous_message}
        </div>
    );
}

function MilestoneBox(props) {
    return (
        <div className={`milestone_box ${props.font}`}>
            <div className='milestone_box_label'>Milestones</div>
            {props.data.map((milestone, index) => (
                <Milestone key={index} data={milestone}/>
            ))}
        </div>
    );
}

export default MilestoneBox
