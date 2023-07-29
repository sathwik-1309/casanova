import {useParams} from "react-router-dom";
import {BACKEND_API_URL} from "../../../my_constants";
import {React, useEffect, useState} from "react";
import PlayerPerfBox from "../../../components/Player/PlayerPerfBox/PlayerPerfBox";

function PlayerScores(props) {
    let { p_id } = useParams();
    let url = `${BACKEND_API_URL}/player/${p_id}/scores`
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
        <div className='player_scores_page flex-col gap-60 default-font'>
            {data.map((player, index) => (
                <PlayerPerfBox data={player} type='score'/>
                ))}
        </div>
    );
}

export default PlayerScores
