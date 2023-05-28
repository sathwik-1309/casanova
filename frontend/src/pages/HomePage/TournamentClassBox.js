import './TournamentClassBox.css'

function TournamentClassBox(props) {
    const data = props.data
    return (
        <a className={`home_navbar_item default-font`} href={`http://localhost:3000/tournaments/${data.tour_name.toLowerCase()}`}>
            <div className="tc_box_tourname">
                {data.tour_name}
            </div>
            <div className={`tc_box_champions ${data.w_color}1`}>
                <div className='tc_box_label'>🏆 WINNERS 🏆</div>
                <div className='tc_box_teamname'>{data.w_teamname}</div>
            </div>
            <div className='tc_box_data'>Tournaments: {data.tournaments}</div>
            <div className='tc_box_data'>Matches: {data.matches}</div>

        </a>
    )

    }
export default TournamentClassBox;
