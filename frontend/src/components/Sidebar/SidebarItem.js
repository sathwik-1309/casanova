import './SidebarItem.css'

function SidebarItem(props){
    let link = props.url;

    return(
        <a className="sidebar-item" href={link} >
            {props.name}
        </a>
    )
}

export default SidebarItem;
