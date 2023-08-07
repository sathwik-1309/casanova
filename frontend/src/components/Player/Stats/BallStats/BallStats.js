import './BallStats.css'
import InfoLine from "../Infoline/InfoLine";
import React, {useEffect, useState} from "react";
import Photocard from "../../../Photocard/Photocard";
import photocard from "../../../Photocard/Photocard";
import BestBox from "../BestBox/BestBox";

function BallStats(props) {
    let url = props.url
    const [data, setData] = useState(null);
    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, [url]);
    if (!data) {
        return <div>Loading...</div>;
    }
    let bat = data.ball_stats
    if (!bat) return <></>
    let stat_header = (props.header === true)? <div className='h-35 font-600 flex-centered font-1'>BOWLING STATS</div> : <></>
    let photocard = (props.pic === true)? <Photocard p_id={data.p_id} height='85px'/>: <></>

    return (
        <div className='ball_stats flex-col w-507 default-font bg-white p-3 font-500 font-1'>
            {stat_header}
            <div className={`bs_headers flex-col h-85 lp-20 ${data.color}1`}>
                <div className='flex-row'>
                    {photocard}
                    <div className='flex-col'>
                        <div className='bs_header1 h-45 font-1_2 flex vert-align font-600'>{data.name}</div>
                        <div className='bs_header2 h-40 font-0_9 flex vert-align'>{data.teamname}</div>
                    </div>
                </div>
            </div>
            <div className='bs_info flex-row'>
                <div className='bs_info_left_box flex-col'>
                    <InfoLine color={data.color} label='Matches' value={bat.matches}/>
                    <InfoLine color={data.color} label='Innings' value={bat.innings}/>
                    <InfoLine color={data.color} label='Wickets' value={bat.wickets} bold={true}/>
                    <InfoLine color={data.color} label='Economy' value={bat.economy} bold={true}/>
                    <InfoLine color={data.color} label='Average' value={bat.avg}/>
                    <InfoLine color={data.color} label='Dot %' value={bat.dot_p}/>
                    <InfoLine color={data.color} label='Boundary %' value={bat.boundary_p}/>
                </div>
                <div className='bs_info_right_box flex-col'>
                    <InfoLine color={data.color} label='Overs' value={bat.overs}/>
                    <InfoLine color={data.color} label='Maidens' value={bat.maidens}/>
                    <InfoLine color={data.color} label='Strike-Rate' value={bat.sr}/>
                    <InfoLine color={data.color} label='3W +' value={bat.three_wickets} bold={true}/>
                    <InfoLine color={data.color} label='5W +' value={bat.five_wickets}/>
                    <BestBox data={bat.best_spell} type={'spell'}/>
                </div>
            </div>
        </div>
    );
}

export default BallStats
