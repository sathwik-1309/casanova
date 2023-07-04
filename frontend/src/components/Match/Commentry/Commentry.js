import {BACKEND_API_URL} from "../../../my_constants";
import React, {useEffect, useState} from "react";
import './Commentry.css'

function OverBox(props) {
    let batsman2 = <></>
    let over = props.over
    if (over.batsman2) {
        batsman2 = <>
            <div className='co_header_batsman'>
                <div className='co_header_batsman_name'>{over.batsman2.name}</div>
                <div className='co_header_batsman_runs'>{over.batsman2.runs}</div>
                <div className='co_header_batsman_balls'>{over.batsman2.balls}</div>
            </div>
        </>
    }
    return (
        <div className='commentry_overbox'>
            <div className='co_header'>
                <div className='co_header_row1'>
                    <div className='co_header_overs'>OVER {over.over_no}</div>
                    <div className='co_header_sequence'>{over.sequence} <span className='co_header_total_runs'>({over.runs} RUNS)</span></div>
                    <div className='co_header_teamname'>{over.teamname}</div>
                    <div className='co_header_score'>{over.score}</div>
                </div>
                <div className='co_header_row2'>
                    <div className='co_header_row2_col1'>
                        <div className='co_header_batsman'>
                            <div className='co_header_batsman_name'>{over.batsman1.name}</div>
                            <div className='co_header_batsman_runs'>{over.batsman1.runs}</div>
                            <div className='co_header_batsman_balls'>{over.batsman1.balls}</div>
                        </div>
                        {batsman2}
                    </div>
                    <div className='co_header_row2_col2'>
                        <div className='co_header_bowler_name'>{over.bowler.name}</div>
                        <div className='co_header_bowler_fig'>{over.bowler.wickets}-{over.bowler.runs} <span className='co_header_bowler_overs'> {over.bowler.overs}</span></div>
                    </div>
                </div>
            </div>
            {over.balls.map((ball, index) => (
                <BallBox ball={ball}/>
            ))}
        </div>

    );
}

function BallBox(props) {
    let ball = props.ball
    let result = 'co_ball_result'
    switch (ball.tag) {
        case "tag_W":
            result += ' co_tag_w'
            break;
        case "tag_4":
            result += ' co_tag_4'
            break;
        case "tag_6":
            result += ' co_tag_6'
            break;
    }
    return (
        <div className='commentry_ballbox'>
            <div className={result}>{ball.result}</div>
            <div className='co_delivery'>{ball.delivery}</div>
            <div className='co_ball_commentry'>{ball.bowler} to {ball.batsman}</div>

        </div>
    );
}


function Commentry(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/${props.inn_no}/commentry`
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
        return <div>Loading...commentry</div>;
    }

    const overs = data.overs

    return (
        <div className='commentry wt20_1'>
            {overs.map((over, index) => (
                <OverBox over={over}/>
            ))}
        </div>
    );
}

export default Commentry
