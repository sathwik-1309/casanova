import { useParams } from 'react-router-dom';
import './TournamentPage.css'
import Pointstable from '../../../components/Tournament/Pointstable/Pointstable';
import BatStats from "../../../components/Tournament/TBatStats/TBatStats";
import BallStats from "../../../components/Tournament/TBallStats/TBallStats";
import Schedules from '../../../components/Tournament/Schedules/Schedules';


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
        case "schedule":
          component = <Schedules t_id={t_id}/>
          break;
        // case "partnerships":
        //     component = <Partnerships m_id = {m_id} inn_no={inn_no}/>
        //   break;
        // case "manhatten":
        //     component = <Manhatten m_id = {m_id} inn_no={inn_no}/>
        //   break;
        default:
            component = component
      }
    return (
        <div id="tournament_page">
            {component}
        </div>
        )

    }
export default TournamentPage;
