import React, {useEffect, useState} from "react";
import './CreateTour.css';
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { BACKEND_API_URL } from "../../my_constants";
import Photocard from "../../components/Photocard/Photocard";

function TourName(props) {
    return (
    <div className={`tour-name flex flex-centered ${props.selected === props.label ? 'tour-selected' : '' }`} onClick={() => props.click(props.label)}>
        {props.label}
    </div>
    )
}

function TeamName(props) {
    const team = props.team
    return (
        <div className={`team-name flex flex-centered font-500 font-0_8 ${props.deselected.includes(team.abbrevation) ? 'team-deselected' : 'tour-selected' }`} onClick={()=> props.click(team.abbrevation, props.deselected)}>
            {team.abbrevation}
        </div>
    )
}

function Squads(props) {
    const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(`${BACKEND_API_URL}/squads?tour_class=${props.tour.toLowerCase()}`);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);

    if (!data) {
        return <div>Loading...</div>;
    }
    
    return (
        data.map((squad, index) => {
            return (<SquadSelection squad={squad} deselected={props.deselected} />)
        })
    );
}

function PlayerBox(props) {
    return (
        <div className={`${props.color}1 flex-row player-box`} onClick={()=> props.click(props.player)}>
            <Photocard p_id={props.player.p_id} color={props.color} height='60px'/>
            <div className="player-name flex flex-centered">{props.player.name}</div>
        </div>
    )
}

function SquadSelection(props) {
    const [batsmen, setBatsmen] = useState(props.squad.players.batsmen)
    const [bowlers, setBowlers] = useState(props.squad.players.bowlers)
    const [allrounders, setAllrounders] = useState(props.squad.players.all_rounders)
    const [count, setCount] = useState(props.squad.players.batsmen.length+props.squad.players.bowlers.length+props.squad.players.all_rounders.length)
    const [playername, setPlayername] = useState('')
    const [suggestions, setSuggestions] = useState([])

    if (props.deselected.includes(props.squad.abbrevation)) {
        return
    }
    const removeBatsman = (player) => {
        setBatsmen(batsmen.filter(e => e !== player));
        setCount(count-1);
    }

    const removeBowler = (player) => {
        setBowlers(bowlers.filter(e => e !== player));
        setCount(count-1);
    }
    const removeAllrounder = (player) => {
        setAllrounders(allrounders.filter(e => e !== player));
        setCount(count-1);
    }

    const handlePlayerSelect = (e) => {
        setPlayername(e.target.value);
        search(e.target.value);
    }

    const search = async (text) => {
        const response = await fetch(`${BACKEND_API_URL}/search/player?pattern=${text}`);
        const result = await response.json();
        setSuggestions(result);
    }

    const addPlayer = (player) => {
        setCount(count+1);
        switch (player.skill) {
            case "BOW":
                setBowlers([...bowlers, player]);
                break;
            case "ALL":
                setAllrounders([...allrounders, player]);
                break;
            default:
                setBatsmen([...batsmen, player]);
                break;
        }
    }

    return (
        <div className="stage1_box font-500 font-1">
            <div className="flex-centered font-1_1 font-600">{props.squad.name}</div>
            <div className="vert-align flex-col">
                <div>
                    <input type="text" 
                    placeholder='Playername'
                    name='name'
                    value={playername}
                    onChange={handlePlayerSelect}/>
                    <div className="absolute suggestion-box vert-align">
                        {playername && suggestions.map((player, index)=> {
                            return (<div className="sb_suggestion" onClick={()=>addPlayer(player)}>{player.name}</div>)
                        })}
                    </div>
                </div>
            </div>
            <div className="flex-centered count-line"> Total Players selected: {count}</div>
            <div className="flex flex-row squad-box">
                <div className="vert-align flex-col skill-box">
                    <div className="skill-tag ">BATSMEN</div>
                    {
                        batsmen.map((player, index)=>{
                            return (<PlayerBox player={player} color={props.squad.color} click={removeBatsman} />)
                        })
                    }
                </div>
                <div className="vert-align flex-col skill-box">
                    <div className="skill-tag">ALL-ROUNDERS</div>
                    {
                        allrounders.map((player, index)=>{
                            return (<PlayerBox player={player} color={props.squad.color} click={removeAllrounder}/>)
                        })
                    }
                </div>
                    <div className="vert-align flex-col skill-box">
                        <div className="skill-tag">BOWLERS</div>
                        {
                            bowlers.map((player, index)=>{
                                return (<PlayerBox player={player} color={props.squad.color} click={removeBowler}/>)
                            })
                        }
                    </div>
                </div>
        </div>
    );
}

function CreateTour(props) {
    const [selectedTour, setselectedTour] = useState(null);
    const [deselectedTeams, setDeselectedTeams] = useState([]);
    const [stage, setStage] = useState(1);
    const [groupnumber, setGroupnumber] = useState(1);

    const deselectTeam = (team, deselectedTeams) => {
        if (deselectedTeams.includes(team)) {
            setDeselectedTeams(deselectedTeams.filter(e => e !== team));
        }else {
            setDeselectedTeams([...deselectedTeams, team]);
        }
    }

    const selectTour = (tour) => {
        setselectedTour(tour);
    }

    const [teams, setTeams] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            if (selectedTour === null) return;
            const response = await fetch(`${BACKEND_API_URL}/teams?tour_class=${selectedTour.toLowerCase()}`);
            const jsonData = await response.json();
            setTeams(jsonData[selectedTour.toLowerCase()]);
        };

        fetchData();
    }, [selectedTour]);

    const changeGroupnumber = (n) => {
        setGroupnumber(n);
    }

    let stage1 = <div className="stage1_box flex flex-col flex-centered bg-shadow">
        <div className="tour-list flex flex-row font-1 font-500">
            <TourName label='WT20' click={selectTour} selected={selectedTour}/>
            <TourName label='IPL' click={selectTour} selected={selectedTour}/>
            <TourName label='CSL' click={selectTour} selected={selectedTour}/>
        </div>
        <div>
            <div className="font-500 font-1">Teams</div>
            <div className="flex flex-wrap">
                {
                    teams &&
                    teams.map((team,index)=> {
                        return (<TeamName team={team} click={deselectTeam} deselected={deselectedTeams}/>)
                    })
                }
            </div>
        </div>
        <h1>
        <select>
            <option>option1</option>
            <option>option2</option>
            <option>option3</option>
            <option>option4</option>
        </select>
        </h1>
        <div className="done_button flex flex-centered font-1 font-500" onClick={()=> setStage(2)}>
            Next
        </div>
    </div>

    let stage2 = <div className="flex-col flex-centered stage1_box">
        <div className="font-500 font-1 flex-centered">Select number of groups</div>
        <div className="flex-row">
            <div className={`group-number flex-centered ${groupnumber === 1 ? 'group-number-selected' : ''}`} onClick={()=>changeGroupnumber(1)}>1</div>
            <div className={`group-number flex-centered ${groupnumber === 2 ? 'group-number-selected' : ''}`} onClick={()=>changeGroupnumber(2)}>2</div>
            <div className={`group-number flex-centered ${groupnumber === 3 ? 'group-number-selected' : ''}`} onClick={()=>changeGroupnumber(3)}>3</div>
            <div className={`group-number flex-centered ${groupnumber === 4 ? 'group-number-selected' : ''}`} onClick={()=>changeGroupnumber(4)}>4</div>
        </div>
        <div className="done_button flex flex-centered font-1 font-500" onClick={()=> setStage(3)}>
            Next
        </div>
    </div>

    let group_arr = Array.from({ length: groupnumber }, (_, index) => index);
    let stage3 = <div className="flex-col flex-centered stage1_box">
        <div className="flex-row flex-centered">
            {
                teams &&
                teams.map((team,index)=> {
                    return (<TeamName team={team} deselected={deselectedTeams}/>)
                })
            }
        </div>
        <div className="flex-row">
                {
                    group_arr.map((n)=>{
                        return (
                            <div>hello</div>
                        )
                    })
                }
            </div>
    </div>

    let stage4 = <div className="flex flex-col flex-centered">
        <Squads tour={selectedTour} deselected={deselectedTeams} />
        <div className="done_button flex flex-centered font-1 font-500" onClick={()=> setStage(4)}>
            Next
        </div>
    </div>

    let stageCode;
    switch (stage) {
        case 1:
            stageCode = stage1;
            break;
        case 2:
            stageCode = stage2;
            break;
        case 3:
            stageCode = stage3;
            break;
        case 4:
            stageCode = stage4;
            break;

    }
    
  return (
   <div className="flex flex-col default-font">
    {stageCode}
   </div>
  )
}

export default CreateTour;