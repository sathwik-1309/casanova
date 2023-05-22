import './Partnerships.css'
import '../css/teams.css'
import React, { useState, useEffect } from 'react'; 

function Header(props) {
    let class1 = "partnership_header1 " + props.color + "1"
    let class2 = "partnership_header2 " + props.color + "2"
    return (
        <div id="partnership_header">
            <div className={class1}>
                {props.teamname}
            </div>
            <div className={class2}>
                PARTNERSHIPS
            </div>
        </div>
    );
}

function Namebox(x) {
    let class1 = "partnership_namebox_name "+x.color+"1"
    let class2 = "partnership_namebox_score "+x.color+"2"
    return (
        <div className='partnership_namebox'>
            <div className={class1}>
                {x.name}
            </div>
            <div className={class2}>
                <div className='partnership_namebox_score_runs'>
                    {x.runs}
                </div>
                <div className='partnership_namebox_score_balls'>
                    {x.balls}
                </div>
            </div>
        </div>
    );
}

function Graphics(x) {
    let b1s = x.x.b1s
    let b2s = x.x.b2s
    let b1p = Math.round((b1s/80)*47)
    let b2p = Math.round((b2s/80)*47)
    console.log(b1p)
    console.log(b2p)
    const b1_width = `${b1p}%`;
    const b1_remaining = `${47 - b1p}%`;
    const b2_width = `${b2p}%`;
    const b2_remaining = `${47 - b2p}%`;

    const b1_1 = {
        width: b1_remaining
      };
    
    const b1_2 = {
        width: b1_width
      };
    const b2_1 = {
        width: b2_width
      };
    
    const b2_2 = {
        width: b2_remaining
      };

    let class1 = "graphic_box_graphics_b1_2 "+x.x.color+"1"
    let class2 = "graphic_box_graphics_b2_1 "+x.x.color+"1"
    return (
        <div id="graphic_box_graphics">
            <div style={b1_1} id="graphic_box_graphics_b1_1"></div>
            <div style={b1_2} className={class1}></div>
            <div id="graphic_box_empty_space"></div>
            <div style={b2_1} className={class2}></div>
            <div style={b2_2} id="graphic_box_graphics_b2_2"></div>
        </div>
    );
}

function GraphicBox(x) {
    let class3 =" "
    return(
    <div id="graphic_box">
        <div id="graphic_box_empty_space_top">
            {class3}
        </div>
        <Graphics x={x}/>
        <div id="graphic_box_2">
            <div id="graphic_box_2_runs">
                {x.runs}
            </div>
            <div id="graphic_box_2_balls">
                {x.balls}
            </div>
        </div>
    </div>
    );
}

function PartnershipItem(x) {

    return (
        <div className='partnership_item'>
            <Namebox name={x.p.b1} color={x.color} runs={x.p.b1s} balls={x.p.b1b}/>
            <GraphicBox color={x.color} runs={x.p.runs} balls={x.p.balls} b1s={x.p.b1s} b2s={x.p.b2s}/>
            <Namebox name={x.p.b2} color={x.color} runs={x.p.b2s} balls={x.p.b2b}/>
        </div>
    );
}

function Partnerships(props) {
    let url = "http://localhost:3001/match/" + props.m_id + "/"+props.inn_no + "/partnerships"
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
        return <div>Loading...bowling_card</div>;
      }

    console.log(data)

    let class1 = "partnerships "+data.tour
    return (
        <div className={class1}>
            <Header color={data.color} teamname={data.teamname}/>
            {data.partnerships.map((p, index) => (
            <PartnershipItem key={index} p={p} color={data.color}/>
            ))}
        </div>

    );
}

export default Partnerships;