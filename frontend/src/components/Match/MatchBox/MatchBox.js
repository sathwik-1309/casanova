import {FRONTEND_API_URL} from "../../../my_constants";
import Logo from "../../Team/Logo/Logo";
import './MatchBox.css'

function MatchBoxItem(props) {
    const inn = props.inn
    return (<div className={`matchbox_inn ${inn.color}1 flex-centered`}>
        <div className="w-30 flex-centered pl-3 h-25">
            <Logo team={inn.color} height={20}/>
        </div>
        <div className='w-45 pl-5 vert-align flex'>
            {inn.teamname}
        </div>
        <div className='matchbox_score'>
            {inn.score}
        </div>
    </div>
    );
}
function MatchBox(props){
    let p = props.data

    return(
        <a className={`matchbox ${p.tour}`} href={`${FRONTEND_API_URL}/match/${p.m_id}/1/summary`}>
            <div className='matchbox_header'>
                {p.tour_name}
            </div>
            <div className='matchbox_body'>
                <MatchBoxItem inn={p.inn1}/>
                <MatchBoxItem inn={p.inn2}/>
            </div>
            <div className='matchbox_footer'>
                {p.venue}
            </div>
        </a>
    )
}

export default MatchBox;
