
// props - stat_type, p_id (url)
import React, {useEffect, useState} from "react";
import BatStats from "../BatStats/BatStats";
import {BACKEND_API_URL} from "../../../../my_constants";
import BallStats from "../BallStats/BallStats";
import './ControlBox.css'

const DropDownBox = (props) => {
    const [isOpen, setIsOpen] = useState(false);
    let options = props.options;

    const toggleMenu = () => {
        setIsOpen(!isOpen);
    };

    const handleOptionSelect = (option) => {
        setIsOpen(false);
        props.func(option)
    };

    return (
        <div className="dropdown-box">
            <div className="dropdown-header" onClick={toggleMenu}>
                {props.selected.toUpperCase()}
                <i className={`arrow-icon ${isOpen ? 'up' : 'down'}`} />
            </div>
            {isOpen && (
                <div className="dropdown-menu flex-col font-1">
                    {options.map((option) => (
                        <div key={option} className='dropdown-menu-item' onClick={() => handleOptionSelect(option)}>
                            {option.toUpperCase()}
                        </div>
                    ))}
                </div>
            )}
        </div>
    );
};


function ControlBox(props) {
    const [url, setUrl] = useState(`${BACKEND_API_URL}/player/${props.p_id}/${props.stat_type}2`);
    const [type, setType] = useState('OVERALL')
    const [subtype, setSubtype] = useState('-')
    const handle_type = (option) => {
        setType(option)
    };
    const handle_subtype = (option) => {
        setSubtype(option)
    };

    const update_stats = (type,subtype) => {
        setUrl(`${BACKEND_API_URL}/player/${props.p_id}/${props.stat_type}2?${type}=${subtype}`)
    };


    let stat_box = props.stat_type === 'bat_stats'? <BatStats url={url}/> : <BallStats url={url}/>
    let stat_box_header = props.stat_type === 'bat_stats'? 'BATTING STATS' : 'BOWLING STATS'
    return (
        <div className='stat_control_box_parent flex-col fit-content bg-white bg-shadow default-font'>
            <div className='h-35 font-600 flex-centered font-1'>{stat_box_header}</div>
            <div className='stat_control_box h-50 font-500 flex-row w-507'>
                <DropDownBox selected={type} func={handle_type} options={Object.keys(props.stat_options)}/>
                <DropDownBox selected={subtype} func={handle_subtype} options={props.stat_options[type.toLowerCase()]}/>
                <div className='cb_submit h-35 w-80 font-0_8 flex-centered' onClick={()=>update_stats(type,subtype)}>SUBMIT</div>
            </div>
            {stat_box}
        </div>
    );
}

export default ControlBox
