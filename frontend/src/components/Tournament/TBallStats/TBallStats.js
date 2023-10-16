import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Listcards from "../Listcards/Listcards";
import { BACKEND_API_URL } from './../../../my_constants'
import BatStats from "../../Player/Stats/BatStats/BatStats";
import BallStats from "../../Player/Stats/BallStats/BallStats";
import BowlerList from '../../Squad/BowlerList/BowlerList';

function TBallStats(props) {
    let { t_id } = useParams();
    let {tour_class} = useParams();

    let url;
    let box_url;
    if (props.t_id){
        url = `${BACKEND_API_URL}/tournament/${t_id}/ball_stats`
        box_url = `ball_stats2?tour=${t_id}`
    }else {
        url = `${BACKEND_API_URL}/tournaments/${tour_class}/ball_stats`
        box_url = `ball_stats2?tour_class=${tour_class}`
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

        <div className={`tournament_ball_stats flex-col ${data.tour}`}>
            <div className='flex-row gap-140 ml-200'>
                {data.ball_stats.boxes.map((lists, index) => (
                    <Listcards key={index} data={lists} func={handleclick}/>
                ))}
            </div>
            <div className='flex-row gap-40'>
                {selected.map((p_id, index) => (
                    <BallStats url={`${BACKEND_API_URL}/player/${p_id}/${box_url}`} header={true} pic={true}/>
                ))}
            </div>
            <div className='w-fit m-hort-500'>
                <BowlerList ball_stats={data.individual_ball_stats}/>
            </div>
        </div>
    )
}

export default TBallStats;
