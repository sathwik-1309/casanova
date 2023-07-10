import { useParams } from 'react-router-dom';
import BowlingCard from '../../components/BowlingCard/BowlingCard';
import Manhatten from '../../components/Manhatten/Manhatten';
import Partnerships from '../../components/Partnerships/Partnerships';
import Scorecard from '../../components/Scorecard/Scorecard';
import Summary from '../../components/Summary/Summary';
import Fow from '../../components/Fow/Fow';
import './MatchPage.css'
import Worm from "../../components/Match/Worm/Worm";
import Commentry from "../../components/Match/Commentry/Commentry";

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
            component = <Scorecard m_id = {m_id} inn_no={inn_no}/>
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
