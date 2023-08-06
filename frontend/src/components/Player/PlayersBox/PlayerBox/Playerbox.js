import Photocard from "../../../Photocard/Photocard";
import React from "react";
import './Playerbox.css'
import {FRONTEND_API_URL} from "../../../../my_constants";

function Playerbox(props) {
    const data = props.data
    return (
        <a className='playerbox wt20_1' href={`${FRONTEND_API_URL}/player/${data.p_id}`}>
            <Photocard height={'114px'} p_id={data.p_id} color={data.color}/>
            <div className={`playerbox_header1 ${data.color}1`}>
                {data.skill}
            </div>
            <div className={`playerbox_name ${data.color}2`}>
                {data.name}
            </div>
        </a>
    );
}

export default Playerbox
