import Photocard from "../../../Photocard/Photocard";
import React from "react";
import './Playerbox.css'

function Playerbox(props) {
    const data = props.data
    return (
        <div className='playerbox wt20_1'>
            <Photocard height={'114px'} p_id={data.p_id} color={data.color}/>
            <div className={`playerbox_header1 ${data.color}1`}>
                {data.skill}
            </div>
            <div className={`playerbox_name ${data.color}2`}>
                {data.name}
            </div>
        </div>
    );
}

export default Playerbox
