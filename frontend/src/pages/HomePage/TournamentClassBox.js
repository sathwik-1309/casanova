import './TournamentClassBox.css'
import { FRONTEND_API_URL } from './../../my_constants';
import Logo from '../../components/Team/Logo/Logo';

function TournamentClassBox(props) {
    const data = props.data
    return (
        <a className={`home_navbar_item default-font`} href={`${FRONTEND_API_URL}/tournaments/${data.tour_name.toLowerCase()}`}>
            <div className="tc_box_tourname">
                {data.tour_name}
            </div>
            <div className={`tc_box_champions`}>
                <div className='tc_box_label'>🏆 WINNERS 🏆</div>
                <div className={`flex-row ${data.w_color}1 flex-centered h-40`}>
                    <Logo team={data.w_color} height={35}/>
                    <div className='pl-10 font-1 fpnt-600'>{data.w_teamname}</div>
                </div>
            </div>
            <div className='tc_box_data'>Tournaments: {data.tournaments}</div>
            <div className='tc_box_data'>Matches: {data.matches}</div>

        </a>
    )

    }
export default TournamentClassBox;
