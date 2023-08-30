import React, {useState} from "react";
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
    const [type, setType] = useState('OVERALL')
    const [subtype, setSubtype] = useState('-')
    const handle_type = (option) => {
        setType(option)
    };
    const handle_subtype = (option) => {
        setSubtype(option)
    };

    const update_url = (type,subtype) => {
        props.func(`${props.base_url}?${type}=${subtype}`)
    };

    return (
            <div className='stat_control_box h-50 font-500 flex-row w-507 default-font bg-white vert-align'>
                <DropDownBox selected={type} func={handle_type} options={Object.keys(props.stat_options)}/>
                <DropDownBox selected={subtype} func={handle_subtype} options={props.stat_options[type.toLowerCase()]}/>
                <div className='cb_submit h-35 w-80 font-0_8 flex-centered' onClick={()=>update_url(type,subtype)}>SUBMIT</div>
            </div>
    );
}

export default ControlBox
