import './BatsmenBox.css'
import BatsmenItem from './BatsmenItem';

function BatsmenBox(props) {
    return (
        <div id='batsmen_box'>
            {props.batsmen.map((batsman, index) => (
            <BatsmenItem key={index} name={batsman[0]} runs={batsman[1]} balls={batsman[2]} notout={batsman[3]} scorebox={batsman[4]} team={props.team} func={props.func}/>
            ))}
        </div>
        );
    
    }
export default BatsmenBox;