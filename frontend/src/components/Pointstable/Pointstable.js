import './Pointstable.css'
import '../css/teams.css'
import React, { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import Photocard from "../Photocard/Photocard";
import PBatStats from "../Player/PBatStats/PBatStats";
import MatchBox from "../Match/MatchBox/MatchBox";
import JourneyBox from "../Tournament/JourneyBox/JourneyBox";


function GroupTableItem(props) {
    let t = props.team
    return (
        <div className={`pt_team ${t.color}1`} onClick={() => props.func(t.team_id)}>
            <div className='pt_team_no'>{t.pos}</div>
            <div className='pt_team_Team'>{t.team}</div>
            <div className='pt_team_P'>{t.played}</div>
            <div className='pt_team_W'>{t.won}</div>
            <div className='pt_team_L'>{t.lost}</div>
            <div className='pt_team_Pts'>{t.points}</div>
            <div className='pt_team_NRR'>{t.nrr}</div>
        </div>
    )
}

function GroupTable(props) {
    return (
        <div className='pt_group'>
            <div className='pt_header'>
                <div className='pt_header_items_1'>Team</div>
                <div className='pt_header_items_2'>P</div>
                <div className='pt_header_items_3'>W</div>
                <div className='pt_header_items_4'>L</div>
                <div className='pt_header_items_5'>Pts</div>
                <div className='pt_header_items_6'>NRR</div>
            </div>
            {props.group.map((team, index) => (
            <GroupTableItem key={index} team={team} func={props.func}/>
            ))}
        </div>
    )
}

// function Pointstable(props) {
//     let { t_id } = useParams();
//
//     let url = `http://localhost:3001/tournament/${t_id}/points_table`
//     const [data, setData] = useState(null);
//     const [journey, setJourney] = useState([]);
//
//     const handleBox = (team_id) => {
//         if (journey.includes(team_id)){
//             setJourney( journey.filter(item => item !== team_id))
//         }
//         else {
//             setJourney([...journey, team_id]);
//         }
//     };
//
//     useEffect(() => {
//         const fetchData = async () => {
//         const response = await fetch(url);
//         const jsonData = await response.json();
//         setData(jsonData);
//         };
//
//         fetchData();
//     }, []);
//
//
//     if (!data) {
//         return <div>Loading...</div>;
//       }
//
//     return (
//         <div className={`pt_parent ${data.tour}`}>
//             <div className={`pt`}>
//                 {data.points_table.map((group, index) => (
//                 <GroupTable key={index} group={group} func={handleBox}/>
//                 ))}
//             </div>
//             <div className='pt_journey_box'>
//                 {journey.map((team_id, index) => (
//                     <JourneyBox journey={data.journeys[team_id.toString()]} key={index}/>
//                 ))}
//             </div>
//         </div>
//     )
//
// }

function MetaItem(props) {
    let p = props.player
    if (props.type === 'batting') {
        return (
            <div className={`meta_item ${p.color}1`}>
                <div className='meta_field3'>{p.pos}</div>
                <div className='meta_playername'>{p.name}</div>
                <div className='meta_field1'>{p.innings}</div>
                <div className='meta_field1 meta_bold'>{p.runs}</div>
                <div className='meta_field2'>{p.avg}</div>
                <div className='meta_field2'>{p.sr}</div>
                <div className='meta_field1'>{p.fours}</div>
                <div className='meta_field1'>{p.sixes}</div>
                <div className='meta_field2'>{p.dot_p} %</div>
                <div className='meta_field2'>{p.boundary_p} %</div>
                <div className='meta_field1'>{p.thirties}</div>
                <div className='meta_field1'>{p.fifties}</div>
                <div className='meta_field3'>{p.hundreds}</div>
                <div className='meta_field_best'>
                    <div className='meta_field_best_runs'>{p.best_runs_with_notout}</div>
                    <div className='meta_field_best_balls'>{p.best_balls}</div>
                </div>
            </div>
        );
    }
    else {
        return (
            <div className={`meta_item ${p.color}1`}>
                <div className='meta_field3'>{p.pos}</div>
                <div className='meta_playername'>{p.name}</div>
                <div className='meta_field1'>{p.innings}</div>
                <div className='meta_field2'>{p.overs}</div>
                <div className='meta_field1 meta_bold'>{p.wickets}</div>
                <div className='meta_field2'>{p.eco}</div>
                <div className='meta_field2'>{p.avg}</div>
                <div className='meta_field2'>{p.sr}</div>
                <div className='meta_field2'>{p.dot_p} %</div>
                <div className='meta_field2'>{p.boundary_p} %</div>
                <div className='meta_field3'>{p._3w}</div>
                <div className='meta_field3'>{p._5w}</div>
                <div className='meta_field3'>{p.maidens}</div>
                <div className='meta_field_best'>
                    <div className='meta_field_best_fig'>{p.best_fig}</div>
                    <div className='meta_field_best_overs'>{p.best_overs}</div>
                </div>
            </div>
        );

    }

}

function SortButton(props) {
    let sort_info = props.sort_info
    let key = props.keys
    let button_class = "button1"
    if (sort_info.state == key) {
        if (sort_info.order == "highest") {
            button_class = "button_highest"
        }
        else {
            button_class = "button_lowest"
        }
    }
    else {
        button_class = "button_off"
    }
    return (
        <div className={`${button_class} sort_button`}>sort</div>
    );
}

function Pointstable(props) {
    let url = ''
    let meta_type = props.type

    if (meta_type === "batting") {
        url = 'http://localhost:3001/players/batting_meta'
    }
    else {
        url = 'http://localhost:3001/players/bowling_meta'
    }

    const [data, setData] = useState(null);
    const [sort_info, set_sort_info] = useState({"state": "innings", "order": "lowest"});
    useEffect(() => {
        const fetchData = async () => {
        const response = await fetch(url);
        const jsonData = await response.json();
        setData(jsonData);
        };

        fetchData();
    }, []);

    const sortByKey = (key) => {
        let sortedData = []
        let order = "highest"
        if (key === "best") {
            if (meta_type === "batting") {
                if (sort_info.order === "highest") {
                    sortedData = [...data.meta].sort((a, b) => {
                        if (a.best_runs === b.best_runs) {
                            return b.best_balls - a.best_balls;
                        }
                        return b.best_runs - a.best_runs;
                    });
                    order = "lowest";
                }
                else {
                    sortedData = [...data.meta].sort((a, b) => {
                        if (a.best_runs === b.best_runs) {
                            return b.best_balls - a.best_balls;
                        }
                        return a.best_runs - b.best_runs;
                    });
                }

            } else {
                if (sort_info.order === "highest") {
                    sortedData = [...data.meta].sort((a, b) => {
                        if (a.best_wickets === b.best_wickets) {
                            return b.best_runs - a.best_runs;
                        }
                        return a.best_wickets - b.best_wickets;
                    });
                    order = "lowest";
                }
                else {
                    sortedData = [...data.meta].sort((a, b) => {
                        if (a.best_wickets === b.best_wickets) {
                            return a.best_runs - b.best_runs;
                        }
                        return b.best_wickets - a.best_wickets;
                    });
                }

            }
        } else {
            if (sort_info.state === key) {
                if (sort_info.order === "highest") {
                    sortedData = [...data.meta].sort((a, b) => b[key] - a[key]);
                    order = "lowest";
                } else {
                    sortedData = [...data.meta].sort((a, b) => a[key] - b[key]);
                }
            } else {
                sortedData = [...data.meta].sort((a, b) => a[key] - b[key]);
            }
        }

        let updatedData = []
        if (order === "lowest") {
            updatedData = sortedData.map((item, index) => ({ ...item, pos: index + 1 }));
        }
        else {
            updatedData = sortedData.map((item, index) => ({ ...item, pos: 20 - index }));
        }

        set_sort_info( {
            "state": key,
            "order": order
        })
        setData({
            "meta": updatedData,
            "font": data.font
        });
    };

    const MetaButtons = () => {
        if (props.type === 'batting' ) {
            return (
                <>
                    <div className='meta_button1' onClick={() => sortByKey('innings')}><SortButton sort_info={sort_info} keys="innings"/></div>
                    <div className='meta_button1' onClick={() => sortByKey('runs')}><SortButton sort_info={sort_info} keys="runs"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('avg')}><SortButton sort_info={sort_info} keys="avg"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('sr')}><SortButton sort_info={sort_info} keys="sr"/></div>
                    <div className='meta_button1' onClick={() => sortByKey('fours')}><SortButton sort_info={sort_info} keys="fours"/></div>
                    <div className='meta_button1' onClick={() => sortByKey('sixes')}><SortButton sort_info={sort_info} keys="sixes"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('dot_p')}><SortButton sort_info={sort_info} keys="dot_p"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('boundary_p')}><SortButton sort_info={sort_info} keys="boundary_p"/></div>
                    <div className='meta_button1' onClick={() => sortByKey('thirties')}><SortButton sort_info={sort_info} keys="thirties"/></div>
                    <div className='meta_button1' onClick={() => sortByKey('fifties')}><SortButton sort_info={sort_info} keys="fifties"/></div>
                    <div className='meta_button3' onClick={() => sortByKey('hundreds')}><SortButton sort_info={sort_info} keys="hundreds"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('best')}><SortButton sort_info={sort_info} keys="best"/></div>
                </>
            );
        }
        else {
            return (
                <>
                    <div className='meta_button1' onClick={() => sortByKey('innings')}><SortButton sort_info={sort_info} keys="innings"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('overs')}><SortButton sort_info={sort_info} keys="overs"/></div>
                    <div className='meta_button1' onClick={() => sortByKey('wickets')}><SortButton sort_info={sort_info} keys="wickets"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('eco')}><SortButton sort_info={sort_info} keys="eco"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('avg')}><SortButton sort_info={sort_info} keys="avg"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('sr')}><SortButton sort_info={sort_info} keys="sr"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('dot_p')}><SortButton sort_info={sort_info} keys="dot_p"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('boundary_p')}><SortButton sort_info={sort_info} keys="boundary_p"/></div>
                    <div className='meta_button3' onClick={() => sortByKey('_3w')}><SortButton sort_info={sort_info} keys="_3w"/></div>
                    <div className='meta_button3' onClick={() => sortByKey('_5w')}><SortButton sort_info={sort_info} keys="_5w"/></div>
                    <div className='meta_button3' onClick={() => sortByKey('maidens')}><SortButton sort_info={sort_info} keys="maidens"/></div>
                    <div className='meta_button2' onClick={() => sortByKey('best')}><SortButton sort_info={sort_info} keys="best"/></div>
                </>
            );
        }
    }

    const MetaHeader = () => {
        if (props.type === 'batting' ) {
            return (
                <>
                    <div className='meta_field1'>RUNS</div>
                    <div className='meta_field2'>AVG</div>
                    <div className='meta_field2'>SR</div>
                    <div className='meta_field1'>4's</div>
                    <div className='meta_field1'>6's</div>
                    <div className='meta_field2'>Dot %</div>
                    <div className='meta_field2'>Bound %</div>
                    <div className='meta_field1'>30's</div>
                    <div className='meta_field1'>50's</div>
                    <div className='meta_field3'>100's</div>
                    <div className='meta_field2'>BEST</div>
                </>
            );
        }
        else {
            return (
                <>
                    <div className='meta_field2'>OVERS</div>
                    <div className='meta_field1'>WICKETS</div>
                    <div className='meta_field2'>ECO</div>
                    <div className='meta_field2'>AVG</div>
                    <div className='meta_field2'>SR</div>
                    <div className='meta_field2'>Dot %</div>
                    <div className='meta_field2'>Bound %</div>
                    <div className='meta_field3'>3-W</div>
                    <div className='meta_field3'>5-W</div>
                    <div className='meta_field3'>MAIDENS</div>
                    <div className='meta_field2'>BEST</div>
                </>
            );
        }

    };

    if (!data) {
        return <div>Loading...</div>;
      }

    return (
        <div className={`meta_parent ${data.font}`}>
            <div className='meta_sort_buttons'>
                <div className='meta_button_empty1'></div>
                <div className='meta_button_empty2'></div>
                <MetaButtons/>
            </div>
            <div className='meta_header'>
                <div className='meta_field3'>#</div>
                <div className='meta_playername'>NAME</div>
                <div className='meta_field1'>INN</div>
                <MetaHeader/>
            </div>
            {data.meta.map((player, index) => (
                <MetaItem key={index} player={player} type={meta_type}/>
                ))}
        </div>
    );
}

export default Pointstable;
