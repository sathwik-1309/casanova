import {useParams} from "react-router-dom";
import {BACKEND_API_URL} from "../../../my_constants";
import {React, useEffect, useState} from "react";
import PlayerPerfBox from "../../../components/Player/PlayerPerfBox/PlayerPerfBox";
import './PlayerPerfPage.css'
import ControlBox from "../../../components/Player/Stats/ControlBox/ControlBox";

function PlayerPerfPage(props) {
    let { p_id } = useParams();
    const base_url = `${BACKEND_API_URL}/player/${p_id}/${props.type}`
    const [url, setUrl] = useState(base_url);
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, [url]);

    const change_url = (url) => {
        setUrl(url)
    }

    if (!data) {
        return <div>Loading...</div>;
    }
    return (
        <div className='player_scores_page flex-col gap-60 default-font'>
            <ControlBox base_url={base_url} stat_options={data.stat_options} func={change_url}/>
            {data[props.type].map((player, index) => (
                <PlayerPerfBox data={player} type={props.type} />
                ))}
        </div>
    );
}

export default PlayerPerfPage
