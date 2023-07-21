import './BatStats.css'
import InfoLine from "../Infoline/InfoLine";

function BatStats(props) {
    let data = props.data
    let bat = data.bat_stats
    return (
        <div className='bat_stats flex-col w-507 default-font bg-white p-3 font-500 font-1'>
            <div className={`bs_headers flex-col lp-20 ${data.color}1`}>
                <div className='bs_header1 h-45 font-1_2 flex vert-align'>{data.name}</div>
                <div className='bs_header2 h-40 flex vert-align'>{data.teamname}</div>
            </div>
            <div className='bs_info flex-row'>
                <div className='bs_info_left_box flex-col'>
                    <InfoLine color={data.color} label='Matches' value={bat.matches}/>
                    <InfoLine color={data.color} label='Innings' value={bat.innings}/>
                    <InfoLine color={data.color} label='Runs' value={bat.runs} bold={true}/>
                    <InfoLine color={data.color} label='Average' value={bat.avg}/>
                    <InfoLine color={data.color} label='Strike-Rate' value={bat.sr} bold={true}/>
                    <InfoLine color={data.color} label='Dot %' value={bat.dot_p}/>
                    <InfoLine color={data.color} label='Boundary %' value={bat.boundary_p}/>
                </div>
                <div className='bs_info_right_box flex-col'>
                    <InfoLine color={data.color} label="Fours" value={bat.fours}/>
                    <InfoLine color={data.color} label='Sixes' value={bat.sixes}/>
                    <InfoLine color={data.color} label='30 +' value={bat.thirties}/>
                    <InfoLine color={data.color} label='50 +' value={bat.fifties} bold={true}/>
                    <InfoLine color={data.color} label='100 +' value={bat.hundreds}/>
                </div>
            </div>
        </div>
    );
}

export default BatStats
