import React from "react";
import './Scorebox.css'
import '../css/teams.css'
import Photocard from "../Photocard/Photocard";

function Scorebox(props) {
    const p = props.data
    return (
        <div onClick={() => props.func(p)} className={`scorebox ${p.tour}`}>
            <div className={`scorebox_pic ${p.color}1`}>
                <Photocard p_id = {p.p_id} height={'85px'}/>
            </div>
            <div className='scorebox_info'>
                <div className='scorebox_header'>
                    <div className={`scorebox_name ${p.color}1`}>{p.name}</div>
                    <div className={`scorebox_score ${p.color}2`}>
                        <div className='scorebox_runs'>{p.score}</div>
                        <div className='scorebox_balls'>{p.balls}</div>
                    </div>
                </div>
                <div className={`scorebox_body ${p.color}1`}>
                    <div className={`scorebox_labels`}>
                        <div className='scorebox_label_item_sr'>SR</div>
                        <div className='scorebox_label_item'>4's</div>
                        <div className='scorebox_label_item'>6's</div>
                        <div className='scorebox_label_item'>0's</div>
                        <div className='scorebox_label_item'>1's</div>
                        <div className='scorebox_label_item'>2's</div>
                        <div className='scorebox_label_item'>3's</div>
                    </div>
                    <div className={`scorebox_data`}>
                        <div className={`scorebox_data_item_sr scorebox_bold ${p.color}2`}>{p.sr}</div>
                        <div className='scorebox_data_item scorebox_bold'>{p.fours}</div>
                        <div className='scorebox_data_item scorebox_bold'>{p.sixes}</div>
                        <div className='scorebox_data_item'>{p.dots}</div>
                        <div className='scorebox_data_item'>{p.ones}</div>
                        <div className='scorebox_data_item'>{p.twos}</div>
                        <div className='scorebox_data_item'>{p.threes}</div>
                    </div>
                </div>
            </div>
        </div>
    );
}
export default Scorebox;
