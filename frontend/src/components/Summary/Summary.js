import './Summary.css'
import React, { useState, useEffect } from 'react';
import SummaryInnings from './SummaryInnings';
import SummaryFooter from './SummaryFooter';
import SummaryHeader from './SummaryHeader';
import BatsmenItem from "./BatsmenItem";
import Scorebox from "../Scorebox/Scorebox";
import PerformanceBox from "../PerformanceBox/PerformanceBox";

function Summary(props) {

    let url = `http://localhost:3001/match/${props.m_id}/summary`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
        const response = await fetch(url);
        const jsonData = await response.json();
        setData(jsonData);
        };

        fetchData();
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

    if (!data) {
        return <div>Loading...</div>;
      }
    let class1 = "summary " + data.tour

    return (
        <div className='summary_parent'>
            <div className={class1}>
                <SummaryHeader header={data.header}/>
                <SummaryInnings inn={data.inn1} tour={data.tour} func={handleBox}/>
                <SummaryInnings inn={data.inn2} tour={data.tour} func={handleBox}/>
                <SummaryFooter footer={data.footer}/>
            </div>
            <div className='summary_boxes'>
                {boxes.map((box, index) => (
                    <PerformanceBox data={box} index={index} func={handleBox}/>
                ))}
            </div>

        </div>
    )

    }
export default Summary;