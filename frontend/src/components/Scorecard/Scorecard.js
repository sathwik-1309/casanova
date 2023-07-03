import './Scorecard.css'
import '../css/teams.css'
import React, { useState, useEffect } from 'react';
import PerformanceBox from "../PerformanceBox/PerformanceBox";
import { BACKEND_API_URL } from './../../my_constants'

function Header(props) {

    let color = props.header.color
    let class2 = "match_scorecard_header1 " + color + "1"
    let class3 = 'match_scorecard_header_4s ' + color + "1"
    let class4 = 'match_scorecard_header_6s ' + color + "1"
    let class5 = 'match_scorecard_header_score ' + color + "2"
    return (
    <div id="match_scorecard_header">
        <div className={class2}>
            {props.header.teamname}
        </div>
        <div className="match_scorecard_header2">
            <div className={class3}>
                Fours: {props.header.fours}
            </div>
            <div className={class4}>
                Sixes: {props.header.sixes}
            </div>
            <div className={class5}>
                <div id="scorecard_score">
                    {props.header.score}
                </div>
                <div id="scorecard_overs">
                    {props.header.overs}
                </div>
            </div>
        </div>

    </div>
    );
}

function ScoreItem(props) {
    let i = props.item
    let temp1 = "scorecard_out"
    let c1 = "1"
    let c2 = "1"
    if (i.batted && i.not_out) {
        c1 = "2"
        c2 = "1"
        temp1="scorecard_not_out"
    }

    let class1 = 'scorecard_item_batsman ' + props.color + c1
    let class2 = 'scorecard_item_data1 ' + props.color + c1
    let class3 = 'scorecard_item_data2 ' + props.color + c1
    let class4 = ''

    if (i.batted) {
        class4 = 'scorecard_item_score ' + props.color + c1
    }
    else {
        class4 = 'scorecard_item_score ' + props.color + c1
    }

    
    let class5 = 'scorecard_runs '+ temp1
    
    return (
        <div id="scorecard_item" onClick={() => props.func(i.scorebox)}>
            <div className={class1}>
                {i.name}
            </div>
            <div className={class2}>
                {i.data2}
            </div>
            <div className={class3}>
                {i.data1}
            </div>
            <div className={class4}>
                <div className={class5}>
                    {i.runs}
                </div>
                <div id="scorecard_balls">
                    {i.balls}
                </div>
            </div>
        </div>
    );
}

function Scorecard(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/+${props.inn_no}/scorecard`
    
    const [scorecard, setscorecard] = useState(null);

    useEffect(() => {
        const fetchScorecard = async () => {
        const response1 = await fetch(url);
        const jsonscorecard = await response1.json();
        setscorecard(jsonscorecard);
        };

        fetchScorecard();
    }, []);
    const [boxes, setBoxes] = useState([]);

    const handleBox = (box) => {
        if (boxes.includes(box)){
            setBoxes( boxes.filter(item => item !== box))
        }
        else {
            setBoxes([...boxes, box]);
        }
    };


    if (!scorecard) {
        return <div>Loading...Scorecard</div>;
      }

    let class1 = "match_scorecard " + scorecard.tour
    return (
        <div className='scorecard_parent'>
            <div className={class1}>
                <Header header={scorecard.header}/>
                <div id="match_scorecard_body">
                    {scorecard.body.map((item, index) => (
                    <ScoreItem key={index} item={item} color={scorecard.header.color} func={handleBox}/>
                    ))}
                </div>
            </div>
            <div className='scorecard_boxes'>
                {boxes.map((box, index) => (
                    <PerformanceBox data={box} index={index} func={handleBox}/>
                ))}
            </div>
        </div>
        );

    
    }
export default Scorecard;