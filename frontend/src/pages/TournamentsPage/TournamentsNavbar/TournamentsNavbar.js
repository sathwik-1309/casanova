import React from "react";
import './TournamentsNavbar.css'
import TournamentBox from "../TournamentBox/TournamentBox";
function TournamentsNavbar(props) {
    let tours = props.tournaments
    return (
        <div className='tournaments_navbar'>
            {tours.map((data, index) => (
                <TournamentBox key={index} data={data}/>
            ))}
        </div>
    );
}

export default TournamentsNavbar
