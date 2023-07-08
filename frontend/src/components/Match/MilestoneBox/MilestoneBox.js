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
    let [sort, setSort] = useState('all');
    let [ml_data, set_ml_data] = useState(props.data);

    const set_sort = (type_class) => {
        setSort(type_class)
        let filteredData = props.data.filter(function(obj) {
            return obj.type_class === type_class;
        });
        set_ml_data(filteredData)
    };

    return (
        <div className={`milestone_box ${props.font}`}>
            <div className='milestone_box_label'>Milestones</div>
            <div className='milestone_box_buttons'>
                <div className={sort === 'overall' ? 'milestone_box_button_item ml_b_button_selected' : 'milestone_box_button_item'} onClick={() => set_sort('overall')}>OVERALL</div>
                <div className={sort === 'tour_class' ? 'milestone_box_button_item ml_b_button_selected' : 'milestone_box_button_item'} onClick={() => set_sort('tour_class')}>TOUR CLASS</div>
                <div className={sort === 'tour' ? 'milestone_box_button_item ml_b_button_selected' : 'milestone_box_button_item'} onClick={() => set_sort('tour')}>TOUR</div>
                <div className={sort === 'team' ? 'milestone_box_button_item ml_b_button_selected' : 'milestone_box_button_item'} onClick={() => set_sort('team')}>TEAM</div>
            </div>
            {ml_data.map((milestone, index) => (
                <Milestone key={index} data={milestone}/>
            ))}
        </div>
    );
}

export default MilestoneBox
