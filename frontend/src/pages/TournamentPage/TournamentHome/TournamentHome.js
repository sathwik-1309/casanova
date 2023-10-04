import { useParams } from 'react-router-dom';
import React, {useEffect, useState} from "react";
import './TournamentHome.css'
import { team_colors } from '../../../components/Graph/team_colors';
import MatchBox from "../../../components/Match/MatchBox/MatchBox";
import PlayerCard from "../../../components/Player/PlayerCard/PlayerCard";
import AwardBox from "../../../components/Player/AwardBox/AwardBox";
import PieChart from "../../../components/PieChart/PieChart";
import ProgressBar from "../../../components/ProgressBar/ProgressBar";
import { BACKEND_API_URL } from './../../../my_constants';
import UpcomingMatch from "../../../components/Schedule/UpcomingMatch/UpcomingMatch";

function ScheduleBox(props) {
    const matches = props.box
    return(
        <div className='th_schedulebox'>
            <div className='th_schedulebox_label'>UPCOMING MATCHES</div>
            <div className='th_schedulebox_matches'>
                {matches.map((match, index) => (
                    <UpcomingMatch match={match}/>
                ))}
            </div>
        </div>
    );
}

function ThBox1(props) {
    const box1 = props.box
    return (
        <div className='tournament_home_box1'>
            <div className='th_box1_medals'>
                <div className='th_box_champions'>
                    <div className='th_box1_winner_label'>🏆 WINNERS 🏆</div>
                    <div className={`th_box1_winner_team ${box1.winners.color}1`}>{box1.winners.teamname}</div>
                </div>
            </div>
            <div className='th_box_final'>
                <div className='th_box_final_label'>Final</div>
                <MatchBox data={box1.final}/>
            </div>
            <div className='th_box1_gembox'>
                <AwardBox player={box1.gem} award={'gem'}/>
            </div>
        </div>
    );
}

function ThBox2(props) {
    const box2 = props.box
    let awardbox1;
    if (props.ongoing === true) {
        awardbox1 = <></>
    }
    else {
        awardbox1 =
            <div className='th_box_awards_item_parent'>
                <div className='th_box_awards_item_label'>Player of the series</div>
                <AwardBox player={box2.pots} award={'pots'}/>
            </div>
    }
    return (
        <div className='tournament_home_box2'>
            <div className='th_box_awards_item'>
                <div className='th_box_awards_item_row1'>
                    {awardbox1}
                    <div className='th_box_awards_item_parent'>
                        <div className='th_box_awards_item_label'>MVP</div>
                        <AwardBox player={box2.mvp} award={'mvp'}/>
                    </div>
                </div>
                <div className='th_box_awards_item_row2'>
                    <div className='th_box_awards_item_parent'>
                        <div className='th_box_awards_item_label'>Most Runs</div>
                        <AwardBox player={box2.most_runs} award={'most_runs'}/>
                    </div>
                    <div className='th_box_awards_item_parent'>
                        <div className='th_box_awards_item_label'>Most Wickets</div>
                        <AwardBox player={box2.most_wickets} award={'most_wickets'}/>
                    </div>
                </div>
            </div>
        </div>
    );
}
function TournamentHome() {
    let { t_id } = useParams();

    let url = `${BACKEND_API_URL}/tournament/${t_id}`
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);

    if (!data) {
        return <div>Loading...</div>;
    }
    let box1 = data.box1
    let box2 = data.box2
    let box3 = data.tour_stats
    const analysis1 = team_colors.analysis1
    const analysis2 = team_colors.analysis2
    let component1 = <></>
    let component2 = <></>

    if (data.ongoing === true && box1 !== {} && box2 !== {} ) {
        component1 = <ScheduleBox box={box1.upcoming_matches}/>
        component2 = <ThBox2 box={box2} ongoing={true}/>
    }
    else {
        component1 = <ThBox1 box={box1}/>
        component2 = <ThBox2 box={box2} ongoing={false}/>
    }

    return (
        <div className='tournament_home default-font'>
            {component1}
            {component2}
            <div className='tournament_home_box3'>
                <div className='th_box3_row1'>
                    <div className='th_box3_row1_lhs'>
                        <div className='th_box3_matches'>
                            <div className='th_box3_matches_label'>Matches </div>
                            <div className='th_box3_matches_value'>{box3.matches}</div>
                        </div>
                        <div className='th_box3_defended'>
                            <div className='th_box3_defended_label'>Defended </div>
                            <div className='th_box3_defended_value'>{box3.defended}</div>
                        </div>
                        <div className='th_box3_chased'>
                            <div className='th_box3_chased_label'>Chased </div>
                            <div className='th_box3_chased_value'>{box3.chased}</div>
                        </div>
                    </div>
                    <div className='th_box3_row1_rhs'>
                        <PieChart
                             data={[box3.chased, box3.defended]}
                             radius={65}
                             hole={0}
                             colors={[`${analysis2}`,`${analysis1}`]}
                             labels={true}
                             percent={true}
                             strokeWidth={0}
                             stroke={'#fff'}
                        />
                    </div>
                </div>
                <div className='th_box3_row2'>
                    <div className='th_box3_row2_lhs'>
                        <div className='th_box3_row2_lhs_label'>Avg Score </div>
                        <div className='th_box3_row2_lhs_value'>{box3.avg_score}</div>
                    </div>
                    <div className='th_box3_row2_rhs'>
                        <ProgressBar progress={(box3.avg_score*100)/200} label={box3.avg_score} color1={`${analysis1}`} color2={`${analysis2}`}></ProgressBar>
                    </div>
                </div>
                <div className='th_box3_row2'>
                    <div className='th_box3_row2_lhs'>
                        <div className='th_box3_row2_lhs_label'>Avg Wickets </div>
                        <div className='th_box3_row2_lhs_value'>{box3.avg_wickets}</div>
                    </div>
                    <div className='th_box3_row2_rhs'>
                        <ProgressBar progress={(box3.avg_wickets)*100/10} label={box3.avg_wickets} color1={`${analysis1}`} color2={`${analysis2}`}></ProgressBar>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default TournamentHome
