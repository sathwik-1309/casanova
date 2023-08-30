import './Topbar.css'
import {useParams} from "react-router-dom";
import ToggleInnings from "../ToggleInnings/ToggleInnings";
import Searchbar from '../Searchbar/Searchbar.tsx';
import {FRONTEND_API_URL} from "../../my_constants";

function TopbarItem(props) {
    let name;
    const link = props.link
    let classname1 = 'topbar_item'
    const currentURL = window.location.href;
    const selected_arr = currentURL.split('/');
    const selected = selected_arr[selected_arr.length - 1]

    switch (props.name) {
        case "points_table":
            name = "POINTS TABLE"
            if (selected === 'points_table') {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "bat_stats":
            name = "BAT STATS"
            if (selected === 'bat_stats') {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "ball_stats":
            name = "BALL STATS"
            if (selected === 'ball_stats') {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "home":
            name = "HOME"
            break;
        case "summary":
            name = "SUMMARY"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "scorecard":
            name = "SCORECARD"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "bowling_card":
            name = "BOWLING CARD"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        // case "fow":
        //     name = "FOW"
        //     if (selected === props.name) {
        //         classname1 = classname1 + ' topbar_selected'
        //     }
        //     break;
        case "partnerships":
            name = "PARTNERSHIPS"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "manhatten":
            name = "MANHATTEN"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "worm":
            name = "WORM"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "commentry":
            name = "COMMENTRY"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "phase":
            name = "PHASE"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "scores":
            name = "SCORES"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "spells":
            name = "SPELLS"
            if (selected === props.name) {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        default:
            break;
    }
    return (
        <a className={classname1} href={link}>
            {name}
        </a>
    );
}


function Topbar(props) {
    let { t_id } = useParams();
    let { m_id } = useParams();
    let { p_id } = useParams();
    let { inn_no } = useParams();
    let topbar = <></>
    let toggle = <></>
    switch (props.s_id) {
        case 'tour':
            topbar = <>
                <TopbarItem name='home' link={`${FRONTEND_API_URL}/tournament/${t_id}`}/>
                <TopbarItem name='points_table' link={`${FRONTEND_API_URL}/tournament/${t_id}/points_table`}/>
                <TopbarItem name='bat_stats' link={`${FRONTEND_API_URL}/tournament/${t_id}/bat_stats`}/>
                <TopbarItem name='ball_stats' link={`${FRONTEND_API_URL}/tournament/${t_id}/ball_stats`}/>
            </>
            break;
        case 'match':
            toggle = <ToggleInnings inn_no={inn_no}/>
            topbar = <>
                <TopbarItem name='summary' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/summary`}/>
                <TopbarItem name='scorecard' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/scorecard`}/>
                {/* <TopbarItem name='fow' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/fow`}/> */}
                <TopbarItem name='phase' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/phase`}/>
                <TopbarItem name='partnerships' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/partnerships`}/>
                <TopbarItem name='manhatten' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/manhatten`}/>
                <TopbarItem name='worm' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/worm`}/>
                <TopbarItem name='commentry' link={`${FRONTEND_API_URL}/match/${m_id}/${inn_no}/commentry`}/>
            </>
            break;
        case 'players_page':
            topbar = <>
            <Searchbar type='players'/>
            </>
            break;
        case 'player':
            topbar = <>
                <TopbarItem name='home' link={`http://localhost:3000/player/${p_id}`}/>
                <TopbarItem name='scores' link={`http://localhost:3000/player/${p_id}/scores`}/>
                <TopbarItem name='spells' link={`http://localhost:3000/player/${p_id}/spells`}/>
            </>
            break;
        default:
            break;
    }
    return (
        <div className='topbar default-font'>
            {toggle}
            {topbar}
        </div>
    );
}

export default Topbar
