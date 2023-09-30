import './BowlingCard.css'
import '../css/teams.css'
import React, { useState, useEffect } from 'react';
import PerformanceBox from "../PerformanceBox/PerformanceBox";
import { BACKEND_API_URL } from './../../my_constants'

function Header(props) {
    let class1 = "bowling_card_header1 " + props.color + "1"
    let class2 = "bowling_card_header2 " + props.color + "2"
    return (
        <div id="bowling_card_header">
            <div className={class1}>
                {props.teamname}
            </div>
            <div className={class2}>
                <div id='bowling_card_name'>
                    NAME
                </div>
                <div className='bowling_card_header2_items'>
                    O
                </div>
                <div className='bowling_card_header2_items'>
                    D
                </div>
                <div className='bowling_card_header2_items'>
                    R
                </div>
                <div className='bowling_card_header2_items'>
                    W
                </div>
                <div className='bowling_card_header2_items'>
                    E
                </div>
                <div className='bowling_card_header2_items'>
                    M
                </div>
            </div>
        </div>
    );
}

function BowlerItem(x) {
    let class1 = "bowling_card_bowleritem "+x.color+"1"
    return (
        <div className={class1} onClick={() => x.func(x.bowler.spellbox)}>
            <div id="bowling_card_bowleritem_name">
                {x.bowler.name}
            </div>
            <div className="bowling_card_bowleritem_items">
                {x.bowler.overs}
            </div>
            <div className="bowling_card_bowleritem_items">
                {x.bowler.dots}
            </div>
            <div className="bowling_card_bowleritem_items">
                {x.bowler.runs}
            </div>
            <div className="bowling_card_bowleritem_items bold_1">
                {x.bowler.wickets}
            </div>
            <div className="bowling_card_bowleritem_items er_1">
                {x.bowler.er}
            </div>
            <div className="bowling_card_bowleritem_items">
                {x.bowler.maidens}
            </div>
        </div>
    );
}

function BowlingCard(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/${props.inn_no}/bowling_card`
    const [data, setData] = useState(null);
    const [boxes, setBoxes] = useState([]);

    useEffect(() => {
        const fetchData = async () => {
        const response = await fetch(url);
        const jsonData = await response.json();
        setData(jsonData);
        setBoxes([jsonData.pick]);
        };

        fetchData();
    }, []);
    

    const handleBox = (box) => {
        if (boxes.includes(box)){
            setBoxes( boxes.filter(item => item !== box))
        }
        else {
            setBoxes([...boxes, box]);
        }
    };


    if (!data) {
        return <div>Loading...bowling_card</div>;
      }

    let class1 = 'bowling_card bg-white bg-shadow ' + data.tour
    return (
        <div className='bowling_card_parent'>
            <div className={class1}>
                <div className='bowling_card_label font-1 flex-centered font-600'>Bowling Card</div>
                <Header color={data.color} teamname={data.teamname}/>
                {data.bowlers.map((bowler, index) => (
                <BowlerItem key={index} bowler={bowler} color={data.color} func={handleBox}/>
                ))}
            </div>
            <div className='bowling_card_boxes'>
                {boxes.map((box, index) => (
                    <PerformanceBox data={box} index={index} func={handleBox}/>
                ))}
            </div>
        </div>
        );

    }
export default BowlingCard;
