import { useParams } from 'react-router-dom';
import BowlingCard from '../../../components/Match/BowlingCard/BowlingCard';
import Manhatten from '../../../components/Match/Manhatten/Manhatten';
import Partnerships from '../../../components/Match/Partnerships/Partnerships';
import Scorecard from '../../../components/Match/Scorecard/Scorecard';
import Summary from '../../../components/Match/Summary/Summary';
import Fow from '../../../components/Match/Fow/Fow';
import './MatchPage.css'
import Worm from "../../../components/Match/Worm/Worm";
import Commentry from "../../../components/Match/Commentry/Commentry";
import InningsProgression from '../../../components/Match/InningsProgression/InningsProgression';
import TurningPoint from '../../../components/Match/TurningPoint/TurningPoint';
import Rankings, { MatchRankings } from '../../../components/Match/Rankings/MatchRankings';
import PreMatch from '../../../components/Match/PreMatch/PreMatch';

function MatchPage() {
    let { m_id } = useParams();
    let { graphic } = useParams();
    let { inn_no } = useParams();
    let component;
    switch(graphic) {
        case "summary":
            component = <Summary m_id = {m_id}/>
            break;
        case "scorecard":
            component = <div className='flex-col wrap gap-30'>
            <Scorecard m_id = {m_id} inn_no={inn_no}/>
            <BowlingCard m_id = {m_id} inn_no={inn_no}/>
            <Fow m_id = {m_id} inn_no={inn_no}/>
            </div>
            break;
        case "fow":
            component = <Fow m_id = {m_id} inn_no={inn_no}/>
            break;
        case "bowling_card":
            component = <BowlingCard m_id = {m_id} inn_no={inn_no}/>
            break;
        case "partnerships":
            component = <Partnerships m_id = {m_id} inn_no={inn_no}/>
            break;
        case "manhatten":
            component = <Manhatten m_id = {m_id} inn_no={inn_no}/>
            break;
        case "worm":
            component = <Worm m_id = {m_id} inn_no={inn_no}/>
            break;
        case "commentry":
            component = <Commentry m_id = {m_id} inn_no={inn_no}/>
            break;
        case "phase":
            component = <div className='flex-col'>
                <InningsProgression m_id={m_id}/>
            </div>
            break;
        // case "rankings":
        //     component = <Rankings m_id = {m_id}/>
        //     break;
        case "pre_match":
            component = <PreMatch match_id = {m_id}/>
            break
        case "rankings":
            component = <MatchRankings match_id = {m_id}/>
            break
        default:
            component = <Summary m_id = {m_id}/>
      }
    return (
        <div id="match_page">
            <div id="match_page_item1">
                <div>
                    {component}
                </div>
            </div>

        </div>
        )

    }
export default MatchPage;
