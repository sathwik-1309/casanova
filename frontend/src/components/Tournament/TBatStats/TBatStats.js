import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Listcards from "../Listcards/Listcards";
import { BACKEND_API_URL } from './../../../my_constants'
import BatStats from "../../Player/Stats/BatStats/BatStats";
import BatsmanList from '../../Squad/BatsmanList/BatsmanList';

function TBatStats(props) {
    let { t_id } = useParams();
    let {tour_class} = useParams();

    let url;
    if (props.t_id){
        url = `${BACKEND_API_URL}/tournament/${t_id}/bat_stats`
    }else {
        url = `${BACKEND_API_URL}/tournaments/${tour_class}/bat_stats`
    } 
    const [data, setData] = useState(null);
    // const [listcard, setListcard] = useState(null)

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
            // setListcard(0)
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

    // const shiftLeft = () => {
    //     setListcard((listcard+6)%7)
    // }
    // const shiftRight = () => {
    //     setListcard((listcard+8)%7)
    // }

    if (!data) {
        return <div>Loading...</div>;
    }

    return (
        <div className={`tournament_bat_stats flex-col ${data.tour}`}>
            <div className='flex-row gap-140 ml-200'>
                {/* <div onClick={shiftLeft}>left</div> */}
                {/* <Listcards data={data.bat_stats.boxes[listcard]} func={handleclick} /> */}
                {data.bat_stats.boxes.map((lists, index) => (
                    <Listcards key={index} data={lists} func={handleclick}/>
                ))}
                {/* <div onClick={shiftRight}>right</div> */}
            </div>
            <div className='flex-row gap-40'>
                {selected.map((p_id, index) => (
                <BatStats url={`${BACKEND_API_URL}/player/${p_id}/bat_stats2?tour=${t_id}`} header={true} pic={true}/>
                ))}
            </div>
            {/* <div className='w-fit m-hort-500'>
                <BatsmanList bat_stats={data.individual_bat_stats}/>
            </div> */}
            
        </div>
    )
}

export default TBatStats;
