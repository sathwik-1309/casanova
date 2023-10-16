import Sidebar from '../../components/Sidebar/Sidebar'
import './WebPage.css'
import Topbar from "../../components/Topbar/Topbar";

function WebPage(props) {
    let topbar = <></>
    let classname1 = "webpage_layout_item2"
    switch (props.s_id) {
        case "tour":
            classname1 += " webpage_layout_item2_margin"
            topbar = <Topbar s_id='tour'/>
            break;
        case "tour_class":
            classname1 += " webpage_layout_item2_margin"
            topbar = <Topbar s_id='tour_class'/>
            break;
        case "match":
            classname1 += " webpage_layout_item2_margin"
            topbar = <Topbar s_id='match'/>
            break;
        case "players_page":
            classname1 += " webpage_layout_item2_margin"
            topbar = <Topbar s_id='players_page'/>
            break;
        case "player":
            classname1 += " webpage_layout_item2_margin"
            topbar = <Topbar s_id='player'/>
            break;
        case "squad":
            classname1 += " webpage_layout_item2_margin"
            topbar = <Topbar s_id='squad'/>
            break;
    }
    return (
    <div id="webpage_layout">
        <Sidebar s_id={props.s_id} />
        {topbar}
        <div className={classname1}>
            {props.page}
        </div>
    </div>

)}

export default WebPage
