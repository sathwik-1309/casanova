import React from "react";
import './Scorebox.css'
import '../css/teams.css'
import Photocard from "../Photocard/Photocard";
import { FRONTEND_API_URL } from "../../my_constants";

function Scorebox(props) {
    const p = props.data
    let score = p.batted ? p.score : 'DNB'
    let balls = p.batted ? p.balls : ''
    let extra_details = <></>
    if (props.detailed) {
        extra_details = <a className={`scorebox_footer h-30 ${p.color}1 flex-row default-font font-0_8 font-600`} href={`${FRONTEND_API_URL}/match/${p.match_id}/1/summary`}>
            <div className='scorebox_pos w-110 flex vert-align' >no. {p.position}</div>
            <div className='scorebox_venue w-200 flex vert-align'>at {p.venue}</div>
            <div className='scorebox_vs_team w-100 flex vert-align'>vs {p.vs_team}</div>
        </a>
    }
    // let picbox = (props.pic === false) ? <></> : <Photocard p_id = {p.p_id} height={'85px'}/>
    return (
        <div className={`scorebox ${p.tour} bg-white bg-shadow`}>
            <div className='scorebox_part1 flex-row'>
                <div className={`scorebox_pic ${p.color}1`}>
                    <Photocard p_id = {p.p_id} height={'85px'}/>
                </div>
                <div onClick={() => props.func(p)} className='scorebox_info'>
                    <div className='scorebox_header'>
                        <div className={`scorebox_name ${p.color}1`}>{p.name}</div>
                        <div className={`scorebox_score ${p.color}2`}>
                            <div className='scorebox_runs'>{score}</div>
                            <div className='scorebox_balls'>{balls}</div>
                        </div>
                    </div>
                    <div className={`scorebox_body`}>
                        <div className={`scorebox_labels ${p.color}1`}>
                            <div className='scorebox_label_item'>4's</div>
                            <div className='scorebox_label_item'>6's</div>
                            <div className='scorebox_label_item'>0's</div>
                            <div className='scorebox_label_item'>1's</div>
                            <div className='scorebox_label_item'>2's</div>
                            <div className='scorebox_label_item'>3's</div>
                            <div className='scorebox_label_item_sr'>SR</div>
                        </div>
                        <div className={`scorebox_data ${p.color}1`}>
                            <div className='scorebox_data_item scorebox_bold'>{p.fours}</div>
                            <div className='scorebox_data_item scorebox_bold'>{p.sixes}</div>
                            <div className='scorebox_data_item'>{p.dots}</div>
                            <div className='scorebox_data_item'>{p.ones}</div>
                            <div className='scorebox_data_item'>{p.twos}</div>
                            <div className='scorebox_data_item'>{p.threes}</div>
                            <div className={`scorebox_data_item_sr scorebox_bold ${p.color}1`}>{p.sr}</div>
                        </div>
                    </div>
                </div>
            </div>
            {extra_details}
        </div>
    );
}
export default Scorebox;
