import './Navbar.css'
import NavbarItem from './NavbarItem';

function Navbar(props) {

    return (
        <div id="home_navbar">
            <NavbarItem tour="WT20"/>
            <NavbarItem tour="IPL"/>
            <NavbarItem tour="CSL"/>
        </div>
    )

    }
export default Navbar;