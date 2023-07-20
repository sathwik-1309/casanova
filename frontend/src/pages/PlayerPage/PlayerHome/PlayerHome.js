import Photocard from "../../../components/Photocard/Photocard";
import {React, useState, useEffect } from "react";
import {useParams} from "react-router-dom";
import {BACKEND_API_URL} from "../../../my_constants";
import './PlayerHome.css'

function PlayerProfile(props) {
    let data = props.data
    return (
        <div className={`player_profile bg-white w-460 bg-shadow flex-col flex-centered default-font`}>
            <Photocard p_id = {props.p_id} color={data.color} height={'180px'} padding={'2%'} outline={'yes'}/>
            <div className="font-1_2 font-600 h-40 flex vert-align">{data.fullname}</div>
            <div className="font-1 font-600 h-35 lex vert-align">{data.country}</div>
            <div className="pp_info w-450 bg-white flex-row">
                <div className="pp_info_labels w-150 font-1 font-400 flex-col">
                    <div className="pp_info_label h-35 flex vert-align">Role</div>
                    <div className="pp_info_label h-35 flex vert-align">Batting</div>
                    <div className="pp_info_label h-35 flex vert-align">Bowling</div>
                    <div className="pp_info_label h-35 flex vert-align">Teams</div>
                </div>
                <div className="pp_info_values w-300 font-1 font-500 flex-col">
                    <div className="pp_info_value h-35 flex vert-align">{data.role}</div>
                    <div className="pp_info_value h-35 flex vert-align">{data.batting}</div>
                    <div className="pp_info_value h-35 flex vert-align">{data.bowling}</div>
                    <div className="pp_info_value h-35 flex vert-align">{data.teams.join(' , ')}</div>
                </div>
            </div>
        </div>
    );
}

function PlayerHome(props) {
    let { p_id } = useParams();
    let url = `${BACKEND_API_URL}/player/${p_id}`
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
        <div className="player_home flex-row">
            <PlayerProfile p_id={p_id} data={data.profile}/>
        </div>
    );
}

export default PlayerHome
