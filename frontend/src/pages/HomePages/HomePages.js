import { useParams } from 'react-router-dom';
import TBatStats from '../../components/Tournament/TBatStats/TBatStats';
import TBallStats from '../../components/Tournament/TBallStats/TBallStats';
import { Leaderboard } from '../../components/Leaderboard/Leaderboard';

function HomePages() {
    let { page } = useParams();
    let component = <TBatStats/>
    switch(page) {
        case "bat_stats":
            component = <TBatStats/>
          break;
        case "ball_stats":
            component = <TBallStats/>
          break;
        // case "meta":
        //   component = <Schedules t_id={t_id}/>
        //   break;
        // case "partnerships":
        //     component = <Partnerships m_id = {m_id} inn_no={inn_no}/>
        //   break;
        // case "manhatten":
        //     component = <Manhatten m_id = {m_id} inn_no={inn_no}/>
        //   break;
        case "rankings":
          component = <Leaderboard />
        default:
            component = component
      }
    return (
        <div id="tournament_page">
            {component}
        </div>
        )

    }
export default HomePages;
