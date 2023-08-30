import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Listcards from "../Listcards/Listcards";
import { BACKEND_API_URL } from './../../../my_constants'
import BatStats from "../../Player/Stats/BatStats/BatStats";

function TBatStats(props) {
    let { t_id } = useParams();

    let url = `${BACKEND_API_URL}/tournament/${t_id}/bat_stats`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    });

    const [selected, setSelected] = useState([]);
    const handleclick = (p_id) => {
        if (selected.includes(p_id)){
            setSelected( selected.filter(item => item !== p_id))
        }
        else {
            setSelected([...selected, p_id]);
        }
    };

    if (!data) {
        return <div>Loading...</div>;
    }

    return (
        <div className={`tournament_bat_stats flex-col ${data.tour}`}>
            <div className='flex-row gap-140'>
                {data.bat_stats.boxes.map((lists, index) => (
                    <Listcards key={index} data={lists} func={handleclick}/>
                ))}
            </div>
            <div className='flex-row gap-40'>
                {selected.map((p_id, index) => (
                <BatStats url={`${BACKEND_API_URL}/player/${p_id}/bat_stats2?tour=${t_id}`} header={true} pic={true}/>
                ))}
            </div>
        </div>
    )
}

export default TBatStats;
