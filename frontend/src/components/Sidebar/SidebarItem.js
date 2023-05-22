import './SidebarItem.css' 

function SidebarItem(props){
    let link = "404";
    switch(props.name) {
        case "Tournaments":
          link = "http://localhost:3000/summary"
          break;
        case "Matches":
            link = "http://localhost:3000/matches"
            break;
        default:
          link = "404"
          console.log(props.name)
      }
    
    return(
        <a className="sidebar-item" href={link}>
            {props.name}
        </a>
    )
}

export default SidebarItem;