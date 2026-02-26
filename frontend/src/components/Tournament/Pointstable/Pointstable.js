import './Pointstable.css'
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import JourneyBox from '../JourneyBox/JourneyBox'
import { BACKEND_API_URL } from '../../../my_constants';
import Logo from '../../Team/Logo/Logo';



function GroupTableItem(props) {
    let t = props.team
    return (
        <div className={`h-40 flex-row ${t.color}1 font-500 font-0_9 bg-shadow mt-2`} onClick={() => props.func(t.team_id)}>
            <div className='w-40 h-40 flex-centered'>{t.pos}</div>
            <Logo team={t.abbrevation} height={35}/>
            <div className='w-270 h-40 flex vert-align font-0_9 font-600 pl-12'>{t.teamname}</div>
            <div className='w-50 h-40 flex-centered'>{t.played}</div>
            <div className='w-50 h-40 flex-centered'>{t.won}</div>
            <div className='w-50 h-40 flex-centered'>{t.lost}</div>
            <div className='w-50 h-40 flex-centered font-600 font-1'>{t.points}</div>
            <div className='w-100 h-40 flex-centered'>{t.nrr}</div>
        </div>
    )
}

function GroupTable(props) {
    return (
        <div className='flex-col bg-shadow bg-white p-10 font-1 font-600'>
            <div className='flex-row h-40 flex-centered'>
                <div className='w-50 flex-centered'></div>
                <div className='w-300 flex-centered'>Team</div>
                <div className='w-50 flex-centered'>P</div>
                <div className='w-50 flex-centered'>W</div>
                <div className='w-50 flex-centered'>L</div>
                <div className='w-50 flex-centered'>Pts</div>
                <div className='w-100 flex-centered'>NRR</div>
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
    }, []);


    if (!data) {
        return <div>Loading...</div>;
      }

    return (
        <div className={`default-font flex flex-row`}>
            <div className={`flex flex-col mr-10 mt-10`}>
                {data.points_table.map((group, index) => (
                <GroupTable key={index} group={group} func={handleBox}/>
                ))}
            </div>
            <div className='ml-10'>
                {journey.map((team_id, index) => (
                    <JourneyBox journey={data.journeys[team_id.toString()]} key={index}/>
                ))}
            </div>
        </div>
    )

}
export default Pointstable;
