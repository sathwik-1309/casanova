import './Summary.css'
import React, { useState, useEffect } from 'react';
import SummaryInnings from './SummaryInnings';
import SummaryFooter from './SummaryFooter';
import SummaryHeader from './SummaryHeader';
import PerformanceBox from "../PerformanceBox/PerformanceBox";
import { BACKEND_API_URL } from './../../my_constants';
import MilestoneBox from "../Match/MilestoneBox/MilestoneBox";
import HighlightsBox from "../Match/HighlightsBox/HighlightsBox";

function Summary(props) {

    let url = `${BACKEND_API_URL}/match/${props.m_id}/summary`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
        const response = await fetch(url);
        const jsonData = await response.json();
        setData(jsonData);
        };

        fetchData();
    });
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
        <div className='summary_outer_parent'>
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
            <HighlightsBox data={data.highlights} font={data.tour}/>
            <MilestoneBox data={data.milestones} font={data.tour}/>
        </div>
    )

    }
export default Summary;
