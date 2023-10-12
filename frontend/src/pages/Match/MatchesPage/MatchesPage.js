
import './MatchesPage.css'
import React, {useEffect, useState} from "react";
import MatchBox from '../../../components/Match/MatchBox/MatchBox';
import {useParams} from "react-router-dom";
import { BACKEND_API_URL } from '../../../my_constants';

function MatchesPage(props){
    console.log(props)
    let url = `${BACKEND_API_URL}/matches`
    let { tour_class } = useParams()
    let { t_id } = useParams()
    let { p_id } = useParams()
    let { team_id } = useParams()

    if (props.tour_class) {
        url = url + `?tour_class=${tour_class}`
    }
    else if (props.t_id) {
        url = url + `?t_id=${t_id}`
    }
    else if (props.p_id) {
        url = url + `?p_id=${p_id}`
    }else if (props.team_id) {
        url = url + `?team_id=${team_id}`
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

    return (
        <div className='matchespage'>
            {data.map((match, index) => (
                <MatchBox data={match}/>
            ))}
        </div>
    );
}

export default MatchesPage;
