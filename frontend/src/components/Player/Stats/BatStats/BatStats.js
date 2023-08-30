import './BatStats.css'
import InfoLine from "../Infoline/InfoLine";
import React, {useEffect, useState} from "react";
import Photocard from "../../../Photocard/Photocard";
import BestBox from "../BestBox/BestBox";

function BatStats(props) {
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
    let bat = data.bat_stats
    let stat_header = (props.header === true)? <div className='h-35 font-600 flex-centered font-1'>BATTING STATS</div> : <></>
    let photocard = (props.pic === true)? <Photocard p_id={data.p_id} height='85px'/>: <></>

    return (
        <div className='bat_stats flex-col w-507 default-font bg-white p-3 font-500 font-1'>
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
                    <InfoLine color={data.color} label='Runs' value={bat.runs} bold={true}/>
                    <InfoLine color={data.color} label='Average' value={bat.avg}/>
                    <InfoLine color={data.color} label='Strike-Rate' value={bat.sr} bold={true}/>
                    <InfoLine color={data.color} label='Dot %' value={bat.dot_p}/>
                    <InfoLine color={data.color} label='Boundary %' value={bat.boundary_p}/>
                </div>
                <div className='bs_info_right_box flex-col'>
                    <InfoLine color={data.color} label="Fours" value={bat.fours}/>
                    <InfoLine color={data.color} label='Sixes' value={bat.sixes}/>
                    <InfoLine color={data.color} label='30 +' value={bat.thirties}/>
                    <InfoLine color={data.color} label='50 +' value={bat.fifties} bold={true}/>
                    <InfoLine color={data.color} label='100 +' value={bat.hundreds}/>
                    <BestBox data={bat.best_score} type='score'/>
                </div>
            </div>
        </div>
    );
}

export default BatStats
