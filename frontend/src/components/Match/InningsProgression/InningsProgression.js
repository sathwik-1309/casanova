import React, {useEffect, useState} from "react";
import { BACKEND_API_URL } from "../../../my_constants";
import './InningsProgression.css'
import IPPerformers from "./IPPerformers/IPPerformers";

function InningsProgression(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/innings_progression`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    });


    if (!data) {
        return <div>Loading...innings progression</div>;
    }

    return (
        <div className='innings_progression_parent default-font'>
            <div className='innings_progression'>
                <div className='flex-centered font-600 font-1 h-35 bg-black c-white'>PHASE COMPARISION</div>
                <div className='ip_graphic_box'>
                    <InnProgressionPhaseBox data={data.innings_progression.powerplay}/>
                    <InnProgressionPhaseBox data={data.innings_progression.middle}/>
                    <InnProgressionPhaseBox data={data.innings_progression.death}/>
                </div>
                <div className='ip_labels font-0_9'>
                    <div className='ip_label'>POWERPLAY</div>
                    <div className='ip_label'>MIDDLE</div>
                    <div className='ip_label'>DEATH</div>
                </div>
            </div>
            <IPPerformers data={data.performers}/>
        </div>
    );
}

function InnProgressionPhaseBox(props) {
    let phasebar1 = <></>
    let phasebar2 = <></>
    if (props.data[0]) {
        phasebar1 = <PhaseBar data={props.data[0]}/>
    }
    if (props.data[1]) {
        phasebar2 = <PhaseBar data={props.data[1]}/>
    }
    return (
        <div className='ip_phase_box'>
            {phasebar1}
            {phasebar2}
        </div>
    );
}

function PhaseBar(props) {
    let data = props.data
    const height = {
        height: `${data.height}px`
    };
    return (
        <div className='ip_phase_bar'>
            <div className='ip_phase_bar_score'>{data.score}</div>
            <div className={`ip_phase_bar_graph ${data.color}1`} style={height}>{data.teamname}</div>
        </div>
    );
}

export default InningsProgression;
