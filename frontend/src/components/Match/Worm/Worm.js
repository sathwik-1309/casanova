import React, {useEffect, useState} from 'react';
import './Worm.css'
import Graph from "../../Graph/Graph";
import { BACKEND_API_URL } from './../../../my_constants'
import InningsProgression from '../InningsProgression/InningsProgression';

function Worm(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/worm`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);


    if (!data) {
        return <div>Loading...worm</div>;
    }

    return (
        <div className='worm_page default-font'>
            <div className='worm'>
                <Graph
                data1 = {data.inn1.scores}
                data2 = {data.inn2.scores}
                label1 = {data.inn1.teamname}
                label2 = {data.inn2.teamname}
                highlightPoints1={data.inn1.wickets}
                highlightPoints2={data.inn2.wickets}
                team1 = {data.inn1.team_id}
                team2 = {data.inn2.team_id}
                />
                <div className={`worm_line ${data.inn1.color}1`}>
                    <div className='worm_line_teamname'>{data.inn1.teamname}</div>
                    <div className='worm_line_rr'>RR: {data.inn1.rr}</div>
                    <div className='worm_line_score'>{data.inn1.score}</div>
                    <div className='worm_line_overs'>{data.inn1.overs}</div>
                </div>
                <div className={`worm_line ${data.inn2.color}1`}>
                    <div className='worm_line_teamname'>{data.inn2.teamname}</div>
                    <div className='worm_line_rr'>RR: {data.inn2.rr}</div>
                    <div className='worm_line_score'>{data.inn2.score}</div>
                    <div className='worm_line_overs'>{data.inn2.overs}</div>
                </div>
            </div>
            <InningsProgression m_id={props.m_id}/>
        </div>
    );
}

export default Worm;
