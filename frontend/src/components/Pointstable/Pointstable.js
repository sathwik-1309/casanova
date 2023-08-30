import './Pointstable.css'
import '../css/teams.css'
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import JourneyBox from "../Tournament/JourneyBox/JourneyBox";
import { BACKEND_API_URL } from './../../my_constants'



function GroupTableItem(props) {
    let t = props.team
    return (
        <div className={`pt_team ${t.color}1`} onClick={() => props.func(t.team_id)}>
            <div className='pt_team_no'>{t.pos}</div>
            <div className='pt_team_Team'>{t.team}</div>
            <div className='pt_team_P'>{t.played}</div>
            <div className='pt_team_W'>{t.won}</div>
            <div className='pt_team_L'>{t.lost}</div>
            <div className='pt_team_Pts'>{t.points}</div>
            <div className='pt_team_NRR'>{t.nrr}</div>
        </div>
    )
}

function GroupTable(props) {
    return (
        <div className='pt_group'>
            <div className='pt_header'>
                <div className='pt_header_items_1'>Team</div>
                <div className='pt_header_items_2'>P</div>
                <div className='pt_header_items_3'>W</div>
                <div className='pt_header_items_4'>L</div>
                <div className='pt_header_items_5'>Pts</div>
                <div className='pt_header_items_6'>NRR</div>
            </div>
            {props.group.map((team, index) => (
            <GroupTableItem key={index} team={team} func={props.func}/>
            ))}
        </div>
    )
}

function Pointstable(props) {
    let { t_id } = useParams();

    let url = `${BACKEND_API_URL}/tournament/${t_id}/points_table`
    const [data, setData] = useState(null);
    const [journey, setJourney] = useState([]);

    const handleBox = (team_id) => {
        if (journey.includes(team_id)){
            setJourney( journey.filter(item => item !== team_id))
        }
        else {
            setJourney([...journey, team_id]);
        }
    };

    useEffect(() => {
        const fetchData = async () => {
        const response = await fetch(url);
        const jsonData = await response.json();
        setData(jsonData);
        };

        fetchData();
    });


    if (!data) {
        return <div>Loading...</div>;
      }

    return (
        <div className={`pt_parent ${data.tour}`}>
            <div className={`pt`}>
                {data.points_table.map((group, index) => (
                <GroupTable key={index} group={group} func={handleBox}/>
                ))}
            </div>
            <div className='pt_journey_box'>
                {journey.map((team_id, index) => (
                    <JourneyBox journey={data.journeys[team_id.toString()]} key={index}/>
                ))}
            </div>
        </div>
    )

}
export default Pointstable;
