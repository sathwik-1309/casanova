import {BACKEND_API_URL} from "../../../my_constants";
import React, {useEffect, useState} from "react";
import './Commentry.css'

function PercentageBox(props) {
    if (props.data == null) {
        return <></>
    }
    let team1 = props.data[0]
    let team2 = props.data[1]
    const width1 = {
        width: team1.value*2,
    };
    const width2 = {
        width: team2.value*2,
    };
    const empty_height = {
        height: props.height*35 + 20,
    };
    return (
        <div className='co_percentage_box_parent'>
            <div className='co_percentage_box_empty' style={empty_height}></div>
            <div className='co_percentage_box_labels'>
                <div className='co_pb_label1'>{props.bat_team}</div>
                <div className='co_pb_label2'>Win %</div>
                <div className='co_pb_label3'>{props.bow_team}</div>
            </div>
            <div className='co_percentage_box'>
                <div className={`co_pb_team1 ${team1.color}1`} style={width1}>{team1.value}</div>
                <div className={`co_pb_team2 ${team2.color}1`} style={width2}>{team2.value}</div>
            </div>
        </div>
    );
}
function OverBox(props) {
    let batsman2 = <></>
    let over = props.over
    let req_rr = <div className='co_header_req_rr_box'></div>
    if (over.req_rr) {
        req_rr = <div className='co_header_req_rr_box'>
                    <div className='co_header_req_rr_label'>REQ</div>
                    <div className='co_header_req_rr_value'>{over.req_rr}</div>
                </div>
    }
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
            {over.balls.map((ball, index) => (
                <BallBox ball={ball} bat_color={props.bat_color}/>
            ))}
            <div className={`co_header ${props.bat_color}2`}>
                <div className='co_header_row1'>
                    <div className='co_header_overs'>OVER {over.over_no}</div>
                    <div className='co_header_sequence'>{over.sequence} <span className='co_header_total_runs'>({over.runs} RUNS)</span></div>
                    <div className='co_header_crr_box'>
                        <div className='co_header_crr_label'>CRR</div>
                        <div className='co_header_crr_value'>{over.cur_rr}</div>
                    </div>
                    {req_rr}
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
        </div>

    );
}

function BallBox(props) {
    let ball = props.ball
    let result = 'co_ball_result'
    switch (ball.tag) {
        case "tag_W":
            result += ` co_tag_w`
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
            <div className={'co_ball_result_parent'}>
                <div className={result}>{ball.result}</div>
            </div>
            <div className='co_delivery'>{ball.delivery}</div>
            <div className={`co_ball_commentry ${props.bat_color}1`}>{`${ball.bowler} to ${ball.batsman}`}</div>
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
        <div className={`commentry ${data.tour_font}`}>
            <div className='commentry_overboxes'>
                {overs.map((over, index) => (
                    <OverBox over={over} bat_color={data.bat_team_color} bow_color={data.bow_team_color}/>
                ))}
            </div>
            <div className='commentry_percentages'>
                {overs.map((over, index) => (
                    <PercentageBox data={data.percentages[Number(over.over_no)-1]} height={over.balls.length} bat_team={over.p_teamname1} bow_team={over.p_teamname2}/>
                ))}
            </div>
        </div>
    );
}

export default Commentry
