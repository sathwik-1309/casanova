import './Navbar.css'
import TournamentClassBox from "./TournamentClassBox";
import React, { useState, useEffect } from 'react';
import { BACKEND_API_URL } from "./../../my_constants";

function Navbar(props) {
    let url = `${BACKEND_API_URL}/home_page`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    });

    if (!data) {
        return <div>Loading...</div>;
    }

    return (
        <div id="home_navbar">
            {data.tournaments.map((data, index) => (
                <TournamentClassBox key={index} data={data}/>
            ))}
        </div>
    )

    }
export default Navbar;
