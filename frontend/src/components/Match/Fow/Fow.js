import './Fow.css'
import React, { useState, useEffect } from 'react';
import { BACKEND_API_URL } from '../../../my_constants';
import Logo from '../../Team/Logo/Logo';

function Header(props) {
    let class1 = "fow_header1 " + props.color + "1"
    let class2 = "fow_header2 " + props.color + "2"
    return (
        <div id="fow_header">
            <div className={`h-45 flex-centered ${props.color}1`}>
                <div className='flex-row flex-centered h-45'>
                    <Logo team={props.color} height={38}/>
                    <div className='pl-10 font-1 font-600'>{props.teamname}</div>
                </div>
                
            </div>
            <div className={class2}>
                <div id="fow_header2_score">
                    SCORE
                </div>
                <div id="fow_header2_batsman">
                    BATSMAN
                </div>
                <div id="fow_header2_bowler">
                    BOWLER
                </div>
                <div id="fow_header2_delivery">
                    DELIVERY
                </div>
            </div>
        </div>
    );
}

function FowItem(props) {
    let class1 = "fow_item "+props.color+"1"
    return (
        <div className={class1}>
            <div id="fow_item_score">
                {props.item.score}
            </div>
            <div id="fow_item_batsman">
                {props.item.batsman}
            </div>
            <div id="fow_item_bowler">
                {props.item.bowler}
            </div>
            <div id="fow_item_delivery">
                {props.item.delivery}
            </div>
        </div>
    );
}

function Fow(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/${props.inn_no}/fow`
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
        return <div>Loading...fow</div>;
      }

    let class1 = 'fow bg-white bg-shadow ' + data.tour

    return (
        <div className={class1}>
            <div className='font-1 flex-centered font-600 h-35'>FOW</div>
            <Header color={data.color} teamname={data.teamname}/>
            {data.fow.map((item, index) => (
            <FowItem key={index} item={item} color={data.color}/>
            ))}
        </div>
        );

    }
export default Fow;
