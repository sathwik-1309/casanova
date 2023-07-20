import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Listcards from "../Listcards/Listcards";
import { BACKEND_API_URL } from './../../../my_constants'
import RoleIcon from "../../RoleIcon/RoleIcon";

function BatStats(props) {
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
    }, []);

    if (!data) {
        return <div>Loading...</div>;
    }

    return (
        <div className={`tournament_bat_stats ${data.tour}`}>
            {data.bat_stats.boxes.map((lists, index) => (
                <Listcards key={index} data={lists}/>
            ))}
        </div>
    )
}

export default BatStats;
