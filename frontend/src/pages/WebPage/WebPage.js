import Sidebar from '../../components/Sidebar/Sidebar'
import './WebPage.css'

function WebPage(props) {
    return (
    <div id="webpage_layout">
        <div id="webpage_layout_item1">
            <Sidebar/>
        </div>
        <div id="webpage_layout_item2">
            {props.page}
        </div>
    </div>
    
)}

export default WebPage