import './HomePage.css'
import Navbar from "./Navbar";

function HomePage() {
    console.log(process.env)
    const myVariable = process.env.REACT_APP_API_HOST;
    console.log(`My variable is: ${myVariable}`);
    return (
        <div id="home_page">
            <Navbar/>
            <div id="home_page_item2">

            </div>
        </div>
        )

    }
export default HomePage;
