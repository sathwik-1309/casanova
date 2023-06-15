import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Listcards from "../Listcards/Listcards";

function BallStats(props) {
    let { t_id } = useParams();

    let url = `http://localhost:3001/tournament/${t_id}/ball_stats`
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

        <div className={`tournament_ball_stats ${data.tour}`}>
            {data.ball_stats.boxes.map((lists, index) => (
                <Listcards key={index} data={lists}/>
            ))}
        </div>
    )
}

export default BallStats;
