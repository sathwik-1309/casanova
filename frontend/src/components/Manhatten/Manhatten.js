import './Manhatten.css'
import React, { useState, useEffect } from 'react';
import { BACKEND_API_URL } from './../../my_constants'

function Wicket(x) {
    let class1 = "manhatten_2_1_3_3 "+ x.color+"2"
    return (
        <div className={class1}>
            W
        </div>
    );
}

function Header(x) {
    let class1 = "manhatten_1_1 font-600 " + x.color + "1"
    let class2 = "manhatten_1_2 font-600 " + x.color + "2"
    return (
        <div id="manhatten_1">
            <div className={class1}>
                {x.teamname}
            </div>
            <div className={class2}>
                <div id='manhatten_1_2_1'>
                    #
                </div>
                <div id='manhatten_1_2_2'>
                    Bowler
                </div>
                <div id='manhatten_1_2_3'>
                    R
                </div>
                <div id='manhatten_1_2_4'>
                    5
                </div>
                <div id='manhatten_1_2_5'>
                    10
                </div>
                <div id='manhatten_1_2_6'>
                    15
                </div>
                <div id='manhatten_1_2_7'>
                    20
                </div>
                <div id='manhatten_1_2_8'>
                    25
                </div>
                <div id='manhatten_1_2_9'>
                    30
                </div>
            </div>
        </div>
    );
}

function Graphics(x) {
    let runs = x.runs
    let r_w = Math.round((runs/30)*90)
    const r_w2 = `${r_w}%`;
    const runs_width = {
        width: r_w2
      };

    let class1 = "manhatten_2_1_3_1 "+x.color+"2"
    let class2= "manhatten_2_1_3_2 "+x.color+"1"
    let empty = " "
    return (
        <div id="manhatten_2_1_3">
            <div className={class1}>
                {x.runs}
            </div>
            <div style={runs_width}  className={class2}>
                {empty}
            </div>
            {x.wickets.map((w, index) => (
            <Wicket key={index} color={x.color}/>
            ))}
        </div>
    );
}
function ManhattenItem(x) {
    let empty = ""
    let class1 = "manhatten_2_1_1_1 " + x.color + "2"
    let class2 = "manhatten_2_1_1_2 " + x.color + "1"
    return (
        <div id="manhatten_2_1">
            <div id="manhatten_2_1_1">
                <div className={class1}>
                    {x.over.over_no}
                </div>
                <div className={class2}>
                    {x.over.bowler}
                </div>
            </div>
            <div id='manhatten_2_1_2'>
                {empty}
            </div>
            <Graphics color={x.color} runs={x.over.runs} wickets={x.over.wickets}/>

        </div>
    );
}

function Manhatten(props) {
    let url = `${BACKEND_API_URL}/match/${props.m_id}/${props.inn_no}/manhatten`
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
        return <div>Loading...manhatten</div>;
      }

    let class1 = "manhatten bg-white bg-shadow "+ data.tour
    return (
        <div className={class1}>
            <div className='font-1 flex-centered font-600 h-35'>Manhatten</div>
            <Header color={data.color} teamname={data.teamname}/>
            <div id="manhatten_2">
            {data.overs.map((over, index) => (
            <ManhattenItem key={index} over={over} color={data.color}/>
            ))}
            </div>
        </div>
    );
}


export default Manhatten;
