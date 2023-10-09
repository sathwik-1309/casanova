import SidebarItem from "./SidebarItem";
import './Sidebar.css'
import {useParams} from "react-router-dom";
import { FRONTEND_API_URL } from './../../my_constants';

function Sidebar(props){
    const s_id = props.s_id
    let { tour_class } = useParams();
    let { t_id } = useParams();
    let { p_id } = useParams();
    if (s_id === 'home') {
        return(
            <div className="sidebar">
                <SidebarItem name="Home" url={`${FRONTEND_API_URL}/`}/>
                <SidebarItem name="Teams" url={`${FRONTEND_API_URL}/teams`}/>
                <SidebarItem name="Matches" url={`${FRONTEND_API_URL}/matches`}/>
                <SidebarItem name="Venues" url={`${FRONTEND_API_URL}/venues`}/>
                <SidebarItem name="Players" url={`${FRONTEND_API_URL}/players`}/>
                <SidebarItem name="Create" url={`${FRONTEND_API_URL}/create`}/>
            </div>
        );
    }
    else if (s_id === 'tour_class') {
        return(
            <div className="sidebar">
                <SidebarItem name="Home" url={`${FRONTEND_API_URL}/`}/>
                <SidebarItem name="Teams" url={`${FRONTEND_API_URL}/tournaments/${tour_class}/teams`}/>
                <SidebarItem name="Matches" url={`${FRONTEND_API_URL}/tournaments/${tour_class}/matches`}/>
                <SidebarItem name="Venues" url={`${FRONTEND_API_URL}/tournaments/${tour_class}/venues`}/>
                <SidebarItem name="Players" url={`${FRONTEND_API_URL}/tournaments/${tour_class}/players`}/>
            </div>
        );
    }
    else if (s_id === 'tour') {
        return(
            <div className="sidebar">
                <SidebarItem name="Home" url={`${FRONTEND_API_URL}/`}/>
                <SidebarItem name="Squads" url={`${FRONTEND_API_URL}/tournament/${t_id}/squads`}/>
                <SidebarItem name="Matches" url={`${FRONTEND_API_URL}/tournament/${t_id}/matches`}/>
                <SidebarItem name="Venues" url={`${FRONTEND_API_URL}/tournament/${t_id}/venues`}/>
                <SidebarItem name="Players" url={`${FRONTEND_API_URL}/tournament/${t_id}/players`}/>
            </div>
        );
    }
    else if (s_id === 'player') {
        return(
            <div className="sidebar">
                <SidebarItem name="Home" url={`${FRONTEND_API_URL}/`}/>
                <SidebarItem name="Teams" url={`${FRONTEND_API_URL}/player/${p_id}/teams`}/>
                <SidebarItem name="Matches" url={`${FRONTEND_API_URL}/player/${p_id}/matches`}/>
                <SidebarItem name="Venues" url={`${FRONTEND_API_URL}/player/${p_id}/venues`}/>
            </div>
        );
    }
    else {return (
        <div className="sidebar">
            <SidebarItem name="not configured" url='#'/>
            <SidebarItem name="Home" url={`${FRONTEND_API_URL}/`}/>
        </div>
    );

    }

}

export default Sidebar;
