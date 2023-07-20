import './Photocard.css'
import '../css/teams.css'
import {images} from '../images/images.js';

function Photocard(props){
    let img1 = images[props.p_id]
    // if (props.p_id > 400) {
    //     img1 = images[0];
    // }
    let padding = '12%';
    if (props.padding) {
        padding = props.padding
    }
    let img_style = {
        padding: padding
    }

    let height_style = {
        width: props.height,
        height: props.height
    };

    let class1 = `photo_card ${props.color}1`
    if (props.outline) {
        class1 = class1 + ' photocard_outline'
    }


    return (
        <div style = {height_style} className={class1}>
        <img src={img1} style={img_style}className='photo_card_pic' />
    </div>
    );
}

export default Photocard
