import React, {useState} from "react";
import './HighlightsBox.css'
function HighlightsBox(props) {
    return (
        <div className={`highlights_box ${props.font}`}>
            <div className='highlights_box_label'>Highlights</div>
            {props.data.map((hl, index) => (
                <Highlight key={index} data={hl}/>
            ))}
        </div>
    );
}

function Highlight(props) {
    let data = props.data
    let [selected, setSelected] = useState(false);
    let previous_message = <></>
    const set_selected = () => {
        setSelected(!selected);
    };
    if (selected === true) {
        previous_message = <div className='highlight_other'>
            {data.others.map((message, index) => (
                <OtherBox key={index} data={message}/>
            ))}
        </div>
    }
    return (
        <div className='highlight_parent'>
            <div className={`highlight ${data.color}1`} onClick={set_selected}>
                {data.message}
            </div>
            {previous_message}
        </div>
    );
}

function OtherBox(props) {
    return (
        <div className='h_other_item'>
            {props.data}
        </div>
    );
}

export default HighlightsBox
