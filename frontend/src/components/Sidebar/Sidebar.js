import SidebarItem from "./SidebarItem";
import './Sidebar.css'

function Sidebar(){
    return(
        <div className="sidebar">
                <SidebarItem name="Tournaments"/>
                <SidebarItem name="Teams"/>
                <SidebarItem name="Matches"/>
                <SidebarItem name="Venues"/>
                <SidebarItem name="Players"/>
        </div>
    )
}

export default Sidebar;