
import './MatchesPage.css'
import React, {useEffect, useState} from "react";
import BatsmenItem from "../../components/Summary/BatsmenItem";
import MatchBox from "../../components/Match/MatchBox/MatchBox";

function MatchesPage(props){
    let url = 'http://localhost:3001/matches'
    if (props.t_id) {
        url = url + `?t_id=${props.t_id}`
    }
    else if (props.p_id) {
        url = url + `?p_id=${props.p_id}`
    }
    else if (props.venue) {
        url = url + `?venue=${props.venue}`
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
