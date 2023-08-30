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
        default:
            break;
    }
    return (
    <div id="webpage_layout">
        <div id="webpage_layout_item1">
            <Sidebar s_id={props.s_id} />
        </div>
        <div id="webpage_layout2">
            {topbar}
            <div className={classname1}>
                {props.page}
            </div>
        </div>
    </div>

)}

export default WebPage
