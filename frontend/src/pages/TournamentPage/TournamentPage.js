import { useParams } from 'react-router-dom';
import './TournamentPage.css'
import Pointstable from "../../components/Pointstable/Pointstable";
import BatStats from "../../components/Tournament/TBatStats/TBatStats";
import BallStats from "../../components/Tournament/TBallStats/TBallStats";


function TournamentPage() {
    let { t_id } = useParams();
    let { page } = useParams();
    let component = <Pointstable t_id={t_id}/>
    switch(page) {
        case "pointstable":
            component = <Pointstable t_id={t_id}/>
          break;
        case "bat_stats":
            component = <BatStats t_id={t_id}/>
          break;
        case "ball_stats":
            component = <BallStats t_id={t_id}/>
          break;
        // case "partnerships":
        //     component = <Partnerships m_id = {m_id} inn_no={inn_no}/>
        //   break;
        // case "manhatten":
        //     component = <Manhatten m_id = {m_id} inn_no={inn_no}/>
        //   break;
        default:
            break;
      }
    return (
        <div id="tournament_page">
            {/*<div id="tournament_page_item1">*/}
            {/*    <Topbar page={page} t_id={t_id}/>*/}
            {/*</div>*/}
            <div id="tournament_page_item2">
                <div>
                    {component}
                </div>
            </div>

        </div>
        )

    }
export default TournamentPage;
