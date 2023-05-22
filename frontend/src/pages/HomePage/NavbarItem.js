import './NavbarItem.css'

function NavbarItem(props) {

    let link = "http://localhost:3000/tournament/"
    let tour = props.tour
    link = link.concat(tour)

    return (
        <a id="home_navbar_item" href={link}>
            {props.tour}
        </a>
    )

    }
export default NavbarItem;