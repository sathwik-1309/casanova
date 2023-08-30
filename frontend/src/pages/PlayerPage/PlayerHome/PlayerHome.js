import Photocard from "../../../components/Photocard/Photocard";
import {React, useState, useEffect } from "react";
import {useParams} from "react-router-dom";
import {BACKEND_API_URL} from "../../../my_constants";
import './PlayerHome.css'
import ControlBox from "../../../components/Player/Stats/ControlBox/ControlBox";
import BatStats from "../../../components/Player/Stats/BatStats/BatStats";
import BallStats from "../../../components/Player/Stats/BallStats/BallStats";

function Label(props) {
    return (
        <div className={`pp_info_label h-35 flex vert-align font-600 ${props.color}1`}>{props.label}</div>
    );
}
function InfoValue(props) {
    return (
        <div className={`pp_info_value h-35 flex vert-align ${props.color}1`}>{props.value}</div>
    );
}
function PlayerProfile(props) {
    let data = props.data
    return (
        <div className={`player_profile bg-white w-460 bg-shadow flex-col flex-centered default-font`}>
            <Photocard p_id = {props.p_id} color={data.color} height={'180px'} padding={'2%'} outline={'yes'}/>
            <div className="font-1_2 font-600 h-40 flex vert-align">{data.fullname}</div>
            <div className="font-1 font-600 h-35 lex vert-align">{data.country}</div>
            <div className="pp_info w-450 flex-row">
                <div className="pp_info_labels w-100 font-1 font-400 flex-col bg-white">
                    <Label color={data.color} label='Role'/>
                    <Label color={data.color} label='Batting'/>
                    <Label color={data.color} label='Bowling'/>
                    <Label color={data.color} label='Teams'/>
                </div>
                <div className="pp_info_values w-350 font-1 font-500 flex-col bg-white">
                    <InfoValue color={data.color} value={data.role}/>
                    <InfoValue color={data.color} value={data.batting}/>
                    <InfoValue color={data.color} value={data.bowling}/>
                    <InfoValue color={data.color} value={data.teams.join(' , ')}/>
                </div>
            </div>
        </div>
    );
}

function TrophyCabinet(props) {
    let data = props.data
    return (
        <div className='player_trophy_cabinet flex-col w-366 default-font bg-shadow bg-white fit-content'>
            <div className='ptc_header font-1 font-600 flex-centered h-40 bg-white'>TROPHY CABINET</div>
            <TrophyBox1 header='MOTM' value={data.motm}/>
            <div className='flex-row'>
                <TrophyBox1 header='Silver' value={data.silver} width='w-120'/>
                <TrophyBox1 header='Gold' value={data.gold} width='w-120'/>
                <TrophyBox1 header='Bronze' value={data.bronze} width='w-120'/>
            </div>
            <div className='flex-row'>
                <TrophyBox1 header='MVP' value={data.mvp} width='w-120'/>
                <TrophyBox1 header='POTS' value={data.pots} width='w-120'/>
                <TrophyBox1 header='GEM' value={data.gem} width='w-120'/>
            </div>
            <div className='flex-row'>
                <TrophyBox1 header='Golden Bat' value={data.most_runs} width='w-180'/>
                <TrophyBox1 header='Golden Ball ' value={data.most_wickets} width='w-180'/>
            </div>
        </div>
    );
}

function TrophyBox1(props) {
    let class1 = `trophy_box1 ${props.width}`
    return (
        <div className={class1}>
            <div className='trophy_box1_header h-20 flex-centered font-0_7 font-600'>{props.header}</div>
            <div className='trophy_box1_value h-40 flex-centered font-1_2'>{props.value}</div>
        </div>
    );
}

function PlayerHome(props) {
    let { p_id } = useParams();
    let url = `${BACKEND_API_URL}/player/${p_id}`
    const [data, setData] = useState(null);
    const baseBatUrl = `${BACKEND_API_URL}/player/${p_id}/bat_stats2`
    const baseBallUrl = `${BACKEND_API_URL}/player/${p_id}/ball_stats2`
    const [batStatUrl, setBatStatUrl] = useState(baseBatUrl);
    const [ballStatUrl, setBallStatUrl] = useState(baseBallUrl);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    });

    const change_bat_stat_url = (url) => {
        setBatStatUrl(url)
    };
    const change_ball_stat_url = (url) => {
        setBallStatUrl(url)
    };

    if (!data) {
        return <div>Loading...</div>;
    }
    return (
        <div className="player_home flex-col wrap gap-60">
            <div className='flex-row wrap gap-60'>
                <PlayerProfile p_id={p_id} data={data.profile}/>
                <TrophyCabinet data={data.trophy_cabinet}/>
            </div>
            <div className='flex-row wrap gap-60'>
                <div className='flex-col bg-shadow'>
                    <div className='bg-white flex-centered h-40 default-font font-600 font-1'>BATTING STATS</div>
                    <ControlBox p_id={p_id} stat_options={data.stat_options} base_url={baseBatUrl} func={change_bat_stat_url}/>
                    <BatStats url={batStatUrl} pic={true}/>
                </div>
                <div className='flex-col bg-shadow'>
                    <div className='bg-white flex-centered h-40 default-font font-600 font-1'>BOWLING STATS</div>
                    <ControlBox p_id={p_id} stat_options={data.stat_options} base_url={baseBallUrl} func={change_ball_stat_url}/>
                    <BallStats url={ballStatUrl} pic={true}/>
                </div>
            </div>
        </div>
    );
}

export default PlayerHome
