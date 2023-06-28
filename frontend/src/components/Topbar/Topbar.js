import './Topbar.css'
import {useParams} from "react-router-dom";

function TopbarItem(props) {
    let { t_id } = useParams();
    let name = 'Home'
    let link = `http://localhost:3000/tournament/${t_id}`
    let classname1 = 'topbar_item'
    const currentURL = window.location.href;
    const selected_arr = currentURL.split('/');
    const selected = selected_arr[selected_arr.length - 1]

    switch (props.name) {
        case "points_table":
            name = "Points Table"
            link = `http://localhost:3000/tournament/${t_id}/points_table`
            if (selected === 'points_table') {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "bat_stats":
            name = "Bat Stats"
            link = `http://localhost:3000/tournament/${t_id}/bat_stats`
            if (selected === 'bat_stats') {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
        case "ball_stats":
            name = "Ball Stats"
            link = `http://localhost:3000/tournament/${t_id}/ball_stats`
            if (selected === 'ball_stats') {
                classname1 = classname1 + ' topbar_selected'
            }
            break;
    }
    return (
        <a className={classname1} href={link}>
            {name}
        </a>
    );
}


function Topbar(props) {
    return (
        <div className='topbar default-font'>
            <TopbarItem name='home'/>
            <TopbarItem name='points_table'/>
            <TopbarItem name='bat_stats'/>
            <TopbarItem name='ball_stats'/>
        </div>
    );
}

export default Topbar
