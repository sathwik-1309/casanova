import SidebarItem from "./SidebarItem";
import './Sidebar.css'
import {useParams} from "react-router-dom";

function Sidebar(props){
    const s_id = props.s_id
    let { tour_class } = useParams();
    if (s_id === 'home') {
        return(
            <div className="sidebar">
                <SidebarItem name="Home" url='http://localhost:3000/'/>
                <SidebarItem name="Teams" url='http://localhost:3000/teams'/>
                <SidebarItem name="Matches" url='http://localhost:3000/matches'/>
                <SidebarItem name="Venues" url='http://localhost:3000/venues'/>
                <SidebarItem name="Players" url='http://localhost:3000/players'/>
            </div>
        );
    }
    else if (s_id === 'tour_class') {
        return(
            <div className="sidebar">
                <SidebarItem name="Home" url='http://localhost:3000/'/>
                <SidebarItem name="Teams" url={`http://localhost:3000/tournaments/${tour_class}/teams`}/>
                <SidebarItem name="Matches" url={`http://localhost:3000/tournaments/${tour_class}/matches`}/>
                <SidebarItem name="Venues" url={`http://localhost:3000/tournaments/${tour_class}/venues`}/>
                <SidebarItem name="Players" url={`http://localhost:3000/tournaments/${tour_class}/players`}/>
            </div>
        );
    }
    else {return (
        <div className="sidebar">
            <SidebarItem name="not configured" url='#'/>
            <SidebarItem name="Home" url='http://localhost:3000/'/>
        </div>
    );

    }

}

export default Sidebar;
