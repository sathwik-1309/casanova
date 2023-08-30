import './TeamBox.css'
function TeamBox(props) {
    let data = props.data
    return (
        <div className= 'teambox_parent'>
            <div className={`teambox`}>
                <div className={`teambox_trophies`}>{data.trophies}</div>
                <div className={`teambox_teamname ${data.color}1`}>{data.teamname}</div>
                <div className={`teambox_tournaments`}>Tournaments: {data.squads}</div>
                <div className={`teambox_tournaments`}>Won: {data.won} / {data.played}</div>
                <div className={`teambox_tournaments`}>Win_p: {data.win_p} %</div>
            </div>
        </div>
    );
}
export default TeamBox;
