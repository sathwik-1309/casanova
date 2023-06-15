import { useParams } from 'react-router-dom';
import React, {useEffect, useState} from "react";
import './TournamentHome.css'
import MatchBox from "../../../components/Match/MatchBox/MatchBox";
function TournamentHome() {
    let { t_id } = useParams();

    let url = `http://localhost:3001/tournament/${t_id}`
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
    let box1 = data.box1

    return (
        <div className='tournament_home default-font'>
            <div className='tournament_home_box1'>
                <div className='th_box1_medals'>
                    <div className='th_box1_winner_label'>🏆 WINNERS 🏆</div>
                    <div className={`th_box1_winner_team ${box1.winners.color}1`}>{box1.winners.teamname}</div>
                    <div className='th_box1_runner_label'>🥈 RUNNERS 🥈</div>
                    <div className={`th_box1_runner_team ${box1.runners.color}1`}>{box1.runners.teamname}</div>
                </div>
                <MatchBox data={box1.final}/>
            </div>
        </div>
    );
}

export default TournamentHome
