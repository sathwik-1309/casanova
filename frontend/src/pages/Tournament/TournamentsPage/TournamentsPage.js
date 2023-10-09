import {useParams} from "react-router-dom";
import './TournamentsPage.css'
import React, {useEffect, useState} from "react";
import TournamentsNavbar from "./TournamentsNavbar/TournamentsNavbar";
import { BACKEND_API_URL } from '../../../my_constants'

function TournamentsPage(props) {
    let { tour_class } = useParams();
    let url = `${BACKEND_API_URL}/tournaments/${tour_class}`
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
        <div className={`tournaments_page default-font`}>
            <TournamentsNavbar tournaments={data.tournaments}/>
        </div>
    );
}

export default TournamentsPage;
