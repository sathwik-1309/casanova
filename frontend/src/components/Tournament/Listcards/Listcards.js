import './Listcards.css'
import './Listcard1'
import Listcard1 from "./Listcard1";

function Listcards(props) {

    return (
        <div className='listcards'>
        <div className='listcards_header'>{props.data.header}</div>
        {props.data.data.map((listcard, index) => (
            <Listcard1 key={index} data={listcard}/>
        ))}
    </div>
    );
}

export default Listcards