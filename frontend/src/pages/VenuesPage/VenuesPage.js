import React, {useEffect, useState} from 'react';
import './VenuesPage.css'
import {useParams} from "react-router-dom";
import { BACKEND_API_URL } from './../../my_constants'

function VenueBox(props) {
    let data = props.data
    return (
        <div className='venuebox'>
            <div className={`venuebox_venue`}>{data.venue}</div>
            <div className={`venuebox_matches`}>Matches: <span className='venue_bold'>{data.matches}</span></div>
            <div className={`venuebox_stats`}>Won: <span className='venue_bold'>{data.defended} / {data.chased}</span></div>
            <div className={`venuebox_avg_score`}>Avg score: <span className='venue_bold'>{data.avg_score}</span></div>
            <div className={`venuebox_avg_wickets`}>Avg for: <span className='venue_bold'>{data.avg_wickets}</span></div>
        </div>
    );
}
function VenuesPage(props) {
    let {tour_class} = useParams()
    let {t_id} = useParams()
    let url = `${BACKEND_API_URL}/venues`
    const [data, setData] = useState(null);

    if (props.tour_class) {
        url = url + `?tour_class=${tour_class}`
    }
    else if (props.t_id) {
        url = url + `?t_id=${t_id}`
    }

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
        <div className={`venues_page default-font`}>
            {data.map((venue, index) => (
                <VenueBox data={venue}/>
            ))}
        </div>
    );
}
export default VenuesPage;
