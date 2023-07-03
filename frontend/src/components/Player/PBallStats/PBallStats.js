import '../PBatStats/PBatStats.css'
import React, { useState, useEffect } from 'react';
import Photocard from "../../Photocard/Photocard";
import { BACKEND_API_URL } from './../../../my_constants'

function PBallStats(props) {

    let url = `${BACKEND_API_URL}/player/${props.p_id}/ball_stats`
    const [all, setall] = useState(null);
    const [data, setdata] = useState(all ? all.career : null);
    const [selected, setSelected] = useState("career");

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setall(jsonData);
        };
        fetchData();
    }, []);

    useEffect(() => {
        if (all) {
            setdata(all.career);
        }
    }, [all]);

    if (!all) {
        return <div>Loading all...</div>;
    }

    if (!data) {
        return <div>Loading data...</div>;
    }
    const handleCareer = () => {
        setdata(all.career);
        setSelected("career"); // update selected state
    };
    const handleInt = () => {
        setdata(all.int);
        setSelected("int"); // update selected state
    };
    const handleIpl = () => {
        setdata(all.ipl);
        setSelected("ipl"); // update selected state
    };
    const handleCsl = () => {
        setdata(all.csl);
        setSelected("csl"); // update selected state
    };

    const buttonClass = (value) =>
        `p_stat_button_item ${selected === value ? "pstat_selected" : ""}`; // add conditional class

    let int_button = <div></div>
    if (all.int) {
        int_button = <div onClick={handleInt} className={buttonClass("int")}>Interntional</div>
    }
    let ipl_button = <div></div>
    if (all.ipl) {
        ipl_button = <div onClick={handleIpl} className={buttonClass("ipl")}>IPL</div>
    }
    let csl_button = <div></div>
    if (all.csl) {
        csl_button = <div onClick={handleCsl} className={buttonClass("csl")}>CSL</div>
    }

    return (
        <div className={`player_stats ${data.tour}`}>
            <div className={`pstat_box ${data.color}1`}>
                <div className='pstat_header'>
                    <Photocard height={'100px'} p_id={props.p_id}/>
                    <div className='pstat_header_info'>
                        <div className='pstat_header_playername'>
                            {data.playername}
                        </div>
                        <div className='pstat_header_teamname'>
                            {data.teamname}
                        </div>
                    </div>
                </div>
                <div className='p_statbox'>
                    <div className='p_statbox_left '>
                        <div className='p_statbox_keys'>
                            <div className='p_statbox_keys_item'>Matches</div>
                            <div className='p_statbox_keys_item'>Innings</div>
                            <div className='p_statbox_keys_item'>Wickets</div>
                            <div className='p_statbox_keys_item'>Economy</div>
                            <div className='p_statbox_keys_item'>Average</div>
                            <div className='p_statbox_keys_item'>Dot %</div>
                            <div className='p_statbox_keys_item'>Boundary %</div>
                        </div>
                        <div className={`p_statbox_values ${data.color}2`}>
                            <div className='p_statbox_values'>
                                <div className='p_statbox_values_item'>{data.matches}</div>
                                <div className='p_statbox_values_item'>{data.innings}</div>
                                <div className='p_statbox_values_item p_stat_bold'>{data.wickets}</div>
                                <div className='p_statbox_values_item p_stat_bold'>{data.economy}</div>
                                <div className='p_statbox_values_item'>{data.average}</div>
                                <div className='p_statbox_values_item'>{data.dot_p}</div>
                                <div className='p_statbox_values_item'>{data.boundary_p}</div>
                            </div>
                        </div>
                    </div>
                    <div className='pstat_emptybox'></div>
                    <div className='p_statbox_right'>
                        <div className='p_statbox_keys'>
                            <div className='p_statbox_keys_item'>Overs</div>
                            <div className='p_statbox_keys_item'>Maidens</div>
                            <div className='p_statbox_keys_item'>SR</div>
                            <div className='p_statbox_keys_item'>3-w</div>
                            <div className='p_statbox_keys_item'>5-w</div>
                            <div className='p_statbox_keys_item'>Fours</div>
                            <div className='p_statbox_keys_item'>Sixes</div>
                        </div>
                        <div className={`p_statbox_values ${data.color}2`}>
                            <div className='p_statbox_values'>
                                <div className='p_statbox_values_item'>{data.overs}</div>
                                <div className='p_statbox_values_item'>{data.maidens}</div>
                                <div className='p_statbox_values_item'>{data.sr}</div>
                                <div className='p_statbox_values_item p_stat_bold'>{data._3w}</div>
                                <div className='p_statbox_values_item'>{data._5w}</div>
                                <div className='p_statbox_values_item'>{data.fours}</div>
                                <div className='p_statbox_values_item'>{data.sixes}</div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div className='p_stat_buttons wt20_1'>
                <div onClick={handleCareer} className={buttonClass("career")}>Career</div>
                {int_button}
                {ipl_button}
                {csl_button}
            </div>

        </div>
    );

}

export default PBallStats
