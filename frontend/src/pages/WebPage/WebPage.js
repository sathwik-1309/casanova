import Sidebar from '../../components/Sidebar/Sidebar'
import './WebPage.css'
import Pointstable from "../../components/Pointstable/Pointstable";
import Topbar from "../../components/Topbar/Topbar";

function WebPage(props) {
    let topbar = <></>
    switch (props.s_id) {
        case "tour":
            topbar = <Topbar id='tour'/>
            break;
    }
    return (
    <div id="webpage_layout">
        <div id="webpage_layout_item1">
            <Sidebar s_id={props.s_id} />
        </div>
        <div id="webpage_layout2">
            {topbar}
            <div id="webpage_layout_item2">
                {props.page}
            </div>
        </div>
    </div>

)}

export default WebPage
