import { useParams } from 'react-router-dom';
import './TournamentsPage.css'
import Pointstable from '../../../components/Tournament/Pointstable/Pointstable';
import BatStats from "../../../components/Tournament/TBatStats/TBatStats";
import BallStats from "../../../components/Tournament/TBallStats/TBallStats";
import Schedules from '../../../components/Tournament/Schedules/Schedules';
import TournamentsHome from './TournamentsHome/TournamentsHome';
import TBatStats from '../../../components/Tournament/TBatStats/TBatStats';
import TBallStats from '../../../components/Tournament/TBallStats/TBallStats';


function TournamentsPage() {
    let { page } = useParams();
    let { tour_class } = useParams();
    let component = <TournamentsHome tour_class={tour_class}/>
    switch(page) {
        case "bat_stats":
            component = <TBatStats tour_class={tour_class}/>
          break;
        case "ball_stats":
            component = <TBallStats tour_class={tour_class}/>
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
export default TournamentsPage;
