import './BowlersBox.css'
import BowlersItem from './BowlersItem';

function BowlersBox(props) {

    return (
        <div id='bowlers_box'>
            {props.bowlers.map((bowler, index) => (
            <BowlersItem key={index} name={bowler[0]} fig={bowler[1]} overs={bowler[2]} spellbox={bowler[3]} team={props.team} func={props.func}/>
            ))}
        </div>
        );
    
    }

export default BowlersBox;