import React from "react";
import './SpellBox.css'
import '../css/teams.css'
import Photocard from "../Photocard/Photocard";

function SpellBox(props) {
    const p = props.data
    let extra_details = <></>
    if (props.detailed) {
        extra_details = <div className={`scorebox_footer h-30 ${p.color}1 flex-row default-font font-0_8 font-600`}>
            <div className='scorebox_pos w-110 flex vert-align' ></div>
            <div className='scorebox_venue w-200 flex vert-align'>at {p.venue}</div>
            <div className='scorebox_vs_team w-100 flex vert-align'>vs {p.vs_team}</div>
        </div>
    }
    return (
        <div className={`spellbox ${p.tour} bg-white bg-shadow`}>
            <div className='spellbox_part1 flex-row'>
                <div className={`spellbox_pic ${p.color}1`}>
                    <Photocard p_id = {p.p_id} height={'85px'}/>
                </div>
                <div onClick={() => props.func(p)} className='spellbox_info'>
                    <div className='spellbox_header'>
                        <div className={`spellbox_name ${p.color}1`}>{p.name}</div>
                        <div className={`spellbox_fig ${p.color}2`}>{p.fig}</div>
                    </div>
                    <div className={`spellbox_body`}>
                        <div className={`spellbox_labels ${p.color}1`}>
                            <div className='spellbox_label_item'>Ovrs</div>
                            <div className='spellbox_label_item'>Dots</div>
                            <div className='spellbox_label_item'>M</div>
                            <div className='spellbox_label_item'>1's</div>
                            <div className='spellbox_label_item'>4's</div>
                            <div className='spellbox_label_item'>6's</div>
                            <div className='spellbox_label_item_sr'>Eco</div>
                        </div>
                        <div className={`spellbox_data ${p.color}1`}>
                            <div className='spellbox_data_item spellbox_bold'>{p.overs}</div>
                            <div className='spellbox_data_item spellbox_bold'>{p.dots}</div>
                            <div className='spellbox_data_item'>{p.maidens}</div>
                            <div className='spellbox_data_item'>{p.ones}</div>
                            <div className='spellbox_data_item'>{p.fours}</div>
                            <div className='spellbox_data_item'>{p.sixes}</div>
                            <div className={`spellbox_data_item_sr spellbox_bold ${p.color}1`}>{p.economy}</div>
                        </div>
                    </div>
                </div>
            </div>
            {extra_details}
        </div>
    );
}
export default SpellBox;
