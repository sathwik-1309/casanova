import './RoleIcon.css'
import {images} from '../images/images.js';

function RoleIcon(props){
    let img1 = images.icons[props.role]

    const height_style = {
        width: props.height,
        height: props.height
    };

    return (
        <div style = {height_style} className='roleicon'>
        <img src={img1} className='roleicon_image' />
    </div>
    );
}

export default RoleIcon
