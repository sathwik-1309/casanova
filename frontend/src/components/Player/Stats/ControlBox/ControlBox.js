
// props - stat_type, p_id (url)
import React, {useEffect, useState} from "react";
import BatStats from "../BatStats/BatStats";
import {BACKEND_API_URL} from "../../../../my_constants";
import BallStats from "../BallStats/BallStats";

function ControlBox(props) {
    const default_url = `${BACKEND_API_URL}/player/${props.p_id}/${props.stat_type}2`
    let url = `${BACKEND_API_URL}/player/${props.p_id}/${props.stat_type}2`
    if (props.url) {
        url = props.url
    }

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
    let stat_box = props.stat_type === 'bat_stats'? <BatStats data={data}/> : <BallStats data={data}/>
    return (
        <div className='stat_control_box_parent flex-col fit-content'>
            <div className='stat_control_box flex-row w-507'>
            </div>
            {stat_box}
        </div>
    );
}

export default ControlBox
