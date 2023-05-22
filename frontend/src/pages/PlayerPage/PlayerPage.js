import { useParams } from 'react-router-dom';
import Topbar from './Topbar/Topbar';
import './PlayerPage.css'
import PBatStats from "../../components/Player/PBatStats/PBatStats";
import Summary from "../../components/Summary/Summary";
import Scorecard from "../../components/Scorecard/Scorecard";
import PBallStats from "../../components/Player/PBallStats/PBallStats";


function PlayerPage() {
    let { p_id } = useParams();
    let { page}= useParams();
    let component = <PBatStats p_id={p_id}/>
    switch(page) {
        case "bat_stats":
            component = <PBatStats p_id={p_id}/>
            break;
        case "ball_stats":
            component = <PBallStats p_id={p_id}/>
            break;




        default:
            component = <PBatStats p_id={p_id}/>
    }
    return (
        <div id="player_page">
            <div id="player_page_item1">

            </div>
            <div id="player_page_item2">
                <div>
                    {component}
                </div>
            </div>

        </div>
    )

}
export default PlayerPage;