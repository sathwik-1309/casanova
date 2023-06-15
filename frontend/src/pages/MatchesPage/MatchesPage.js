
import './MatchesPage.css'
import React, {useEffect, useState} from "react";
import MatchBox from "../../components/Match/MatchBox/MatchBox";
import {useParams} from "react-router-dom";

function MatchesPage(props){
    let url = 'http://localhost:3001/matches'
    let { tour_class } = useParams()

    if (props.tour_class) {
        url = url + `?tour_class=${tour_class}`
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
