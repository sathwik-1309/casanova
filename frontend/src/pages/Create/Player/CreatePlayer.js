import React, { useState , useEffect, useRef} from 'react';
import './CreatePlayer.css'
import { BACKEND_API_URL, FRONTEND_API_URL } from '../../../my_constants';
import axios from "axios";

function OptionSelect(props) {
    const country = props.country
    return (
        <option value={`${country.id}`}>{country.name}</option>
    )
}

function CreatePlayer() {
  const [selectedCountry, setSelectedCountry] = useState(1);
  const [selectedSkill, setSelectedSkill] = useState('bat');
  const [selectedBowlingStyle, setSelectedBowlingstyle] = useState('n/a');
  const [selectedCslteam, setSelectedCslteam] = useState(31);
  const [selectedIplteam, setSelectedIplteam] = useState(21);
  const [selectedBornteam, setSelectedBornteam] = useState(31);
  const [data, setData] = useState(null);
  const [error, setError] = useState('')

  const [isKeeper, setIsKeeper] = useState(false);
  const [selectedFile, setSelectedFile] = useState(null);
  const [battingHand, setBattingHand] = useState('r');
  const [bowlingHand, setBowlingHand] = useState('n/a');
  const [fullName, setFullName] = useState('');
  const [name, setName] = useState('');

  const handleCslteamChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedCslteam(selectedValue);
  }

  const handleIplteamChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedIplteam(selectedValue);
  }

  const handleBornteamChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedBornteam(selectedValue);
  }

  const handleBowlingstyleChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedBowlingstyle(selectedValue);
  }

  const handleBowlingHandChange = (event) => {
    setBowlingHand(event.target.value);
  };

  const handleBattingHandChange = (event) => {
    setBattingHand(event.target.value);
  };

  const handleFileChange = (event) => {
    setSelectedFile(event.target.files[0]);
  };

  const handleKeeperChange = (event) => {
    setIsKeeper(event.target.checked);
  };
  

  const handleCountryChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedCountry(selectedValue);
  };

  const handleSkillChange = (event) => {
    const selectedValue = event.target.value;
    setSelectedSkill(selectedValue);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const payload = {
        fullname: fullName,
        name: name,
        country_team_id: selectedCountry,
        skill: selectedSkill,
        batting_hand: battingHand,
        bowling_hand: bowlingHand,
        bowling_style: selectedBowlingStyle,
        keeper: isKeeper,
        csl_team_id: selectedCslteam,
        ipl_team_id: selectedIplteam,
        born_team_id: selectedBornteam
    }
    console.log(payload);
    async function CreatePlayer(payload) {
        const response = await axios.post(`${BACKEND_API_URL}/player/create`,payload)
        if (response.status === 202) {
            console.log(response.data.message);
            setError(response.data.message);
        }else if (response.status === 200) {
            setError('');
            const p_id = response.data.id;
            window.location.replace(`${FRONTEND_API_URL}/player/${p_id}`);
        }
    }
    CreatePlayer(payload);
  }

  useEffect(() => {
    const api_call = async () => {
      const response = await axios.get(`${BACKEND_API_URL}/teams/player_create`);
      setData(response.data);
    }
  
    api_call();
  }, []);

  if (!data) {
    return <></>;
  }

  
  return (
    <div className='default-font font-500 font-1'>
        <form onSubmit={handleSubmit}>
            <div>
                <label>Fullname</label>
                <input type="text" placeholder='Fullname' value={fullName} onChange={(e) => setFullName(e.target.value)} required/>
            </div>
            <div>
                <label>Name</label>
                <input type="text" placeholder='Name' value={name} onChange={(e) => setName(e.target.value)} required/>
            </div>
            <div>
                <label>Country</label>
                <select className="select-country" onChange={handleCountryChange} value={selectedCountry}>
                    {
                        data.countries.map((country, index)=> {
                            return (<OptionSelect country={country}/>)  
                        })
                    }
                </select>
            </div>
            <div>
                <label>Skill</label>
                <select id="select-skill" onChange={handleSkillChange} value={selectedSkill}>
                    <option value="bat">Batsman</option>
                    <option value="all">Allrounder</option>
                    <option value="bow">Bowler</option>
                </select>
            </div>
            <div id="batting-hand">
                <label>Batting hand</label>
                <input type="radio" name="batting-hand" value="r" checked={battingHand === 'r'} onChange={handleBattingHandChange}/>Right
                <input type="radio" name="batting-hand" value="l" checked={battingHand === 'l'} onChange={handleBattingHandChange}/>Left
            </div>
            {
                error === ''? <></> :
                <div className='red-error'>
                    {error}
                </div>
            }
            <div id="bowling-hand">
                <label>Bowling hand</label>
                <input type="radio" name="bowling-hand" value="r" checked={bowlingHand === 'r'} onChange={handleBowlingHandChange}/>Right
                <input type="radio" name="bowling-hand" value="l" checked={bowlingHand === 'l'} onChange={handleBowlingHandChange}/>Left
                <input type="radio" name="bowling-hand" value='n/a' checked={bowlingHand == 'n/a'} onChange={handleBowlingHandChange}/>n/a
            </div>
            <div>
                <label>Bowling Style</label>
                <select id="select-bowling-style" onChange={handleBowlingstyleChange} value={selectedBowlingStyle}>
                    <option value="n/a">n/a</option>
                    <option value="fast">Fast</option>
                    <option value="off">Off-spinner</option>
                    <option value="leg">Leg-spinner</option>
                </select>
            </div>
            <div id="keeper">
                <label>Keeper</label>
                <input type="checkbox" onChange={handleKeeperChange}/>
            </div>
            <div>
                <label>CSL Team</label>
                <select className='select-country' onChange={handleCslteamChange} value={selectedCslteam}>
                    <option value="n/a" >n/a</option>
                    {
                        data.csl_teams.map((country, index)=> {
                            return (<OptionSelect country={country}/>)
                        })
                    }
                </select>
            </div>
            <div>
                <label>IPL Team</label>
                <select className='select-country' onChange={handleIplteamChange} value={selectedIplteam}>
                    <option value="n/a" >n/a</option>
                    {
                        data.ipl_teams.map((country, index)=> {
                            return (<OptionSelect country={country}/>)  
                        })
                    }
                </select>
            </div>
            <div>
                <label>Born Team</label>
                <select className='select-country' onChange={handleBornteamChange} value={selectedBornteam}>
                    {
                        data.csl_teams.map((country, index)=> {
                            return (<OptionSelect country={country}/>)  
                        })
                    }
                </select>
            </div>
            {/* <div>
                <label>Upload Picture</label>
                <input type="file" id="upload-player-pic" onChange={handleFileChange} required/>
            </div> */}
            <button>Create</button>
        </form>
    </div>
  )
}

export default CreatePlayer;
