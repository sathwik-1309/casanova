import React from "react";
import './SpellBox.css'
import '../css/teams.css'
import Photocard from "../Photocard/Photocard";

function SpellBox(props) {
    const p = props.data
    return (
        <div className={`spellbox ${p.tour}`}>
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
                        <div className='spellbox_label_item_sr'>Eco</div>
                        <div className='spellbox_label_item'>Ovrs</div>
                        <div className='spellbox_label_item'>Dots</div>
                        <div className='spellbox_label_item'>M</div>
                        <div className='spellbox_label_item'>1's</div>
                        <div className='spellbox_label_item'>4's</div>
                        <div className='spellbox_label_item'>6's</div>
                    </div>
                    <div className={`spellbox_data ${p.color}1`}>
                        <div className={`spellbox_data_item_sr spellbox_bold ${p.color}2`}>{p.economy}</div>
                        <div className='spellbox_data_item spellbox_bold'>{p.overs}</div>
                        <div className='spellbox_data_item spellbox_bold'>{p.dots}</div>
                        <div className='spellbox_data_item'>{p.maidens}</div>
                        <div className='spellbox_data_item'>{p.ones}</div>
                        <div className='spellbox_data_item'>{p.fours}</div>
                        <div className='spellbox_data_item'>{p.sixes}</div>
                    </div>
                </div>
            </div>
        </div>
    );
}
export default SpellBox;
