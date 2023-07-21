import './BallStats.css'
import InfoLine from "../Infoline/InfoLine";

function BallStats(props) {
    let data = props.data
    let bat = data.ball_stats
    return (
        <div className='ball_stats flex-col w-507 default-font bg-white p-3 font-500 font-1'>
            <div className={`bs_headers flex-col lp-20 ${data.color}1`}>
                <div className='bs_header1 h-45 font-1_2 flex vert-align'>{data.name}</div>
                <div className='bs_header2 h-40 flex vert-align'>{data.teamname}</div>
            </div>
            <div className='bs_info flex-row'>
                <div className='bs_info_left_box flex-col'>
                    <InfoLine color={data.color} label='Matches' value={bat.matches}/>
                    <InfoLine color={data.color} label='Innings' value={bat.innings}/>
                    <InfoLine color={data.color} label='Wickets' value={bat.wickets} bold={true}/>
                    <InfoLine color={data.color} label='Economy' value={bat.economy} bold={true}/>
                    <InfoLine color={data.color} label='Average' value={bat.avg}/>
                    <InfoLine color={data.color} label='Dot %' value={bat.dot_p}/>
                    <InfoLine color={data.color} label='Boundary %' value={bat.boundary_p}/>
                </div>
                <div className='bs_info_right_box flex-col'>
                    <InfoLine color={data.color} label='Overs' value={bat.overs}/>
                    <InfoLine color={data.color} label='Maidens' value={bat.maidens}/>
                    <InfoLine color={data.color} label='Strike-Rate' value={bat.sr}/>
                    <InfoLine color={data.color} label='3W +' value={bat.three_wickets} bold={true}/>
                    <InfoLine color={data.color} label='5W +' value={bat.five_wickets}/>
                </div>
            </div>
        </div>
    );
}

export default BallStats
