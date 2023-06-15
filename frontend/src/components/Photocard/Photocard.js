import './Photocard.css'
import '../css/teams.css'
import {images} from '../images/images.js';

function Photocard(props){
    let img1 = images[props.p_id]
    if (props.p_id > 195) {
        img1 = images[0];
    }

    const height_style = {
        width: props.height,
        height: props.height
    };

    return (
        <div style = {height_style} className={`photo_card ${props.color}1`}>
        <img src={img1} className='photo_card_pic' />
    </div>
    );
}

export default Photocard
