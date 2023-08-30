import React, {useEffect, useState} from 'react';
import './PlayersPage.css'
import PlayersBox from "../../components/Player/PlayersBox/PlayersBox";
import {useParams} from "react-router-dom";
import { BACKEND_API_URL } from './../../my_constants'

function DropdownMenu(props) {
    const options = props.teams
    const [isOpen, setIsOpen] = useState(false);
    const [selectedOption, setSelectedOption] = useState(options[0]);

    const toggleDropdown = () => {
        setIsOpen(!isOpen);
    };

    const handleOptionSelect = (option) => {
        setSelectedOption(option);
        setIsOpen(false);
        props.func(option)
    };

    return (
        <div className={`dropdown wt20_1`}>
            <button className="dropdown-toggle" onClick={toggleDropdown}>
                {selectedOption.toUpperCase() || 'Select an option'}
                <span className={`arrow ${isOpen ? 'open' : ''}`}></span>
            </button>
            {isOpen && (
                <ul className="dropdown-menu">
                    {options.map((option) => (
                        <li
                            key={option}
                            className="dropdown-item"
                            onClick={() => handleOptionSelect(option)}
                        >
                            {option.toUpperCase()}
                        </li>
                    ))}
                </ul>
            )}
        </div>
    )
};

function PlayersPage(props) {
    let { tour_class } = useParams()
    let { t_id } = useParams()
    let url = `${BACKEND_API_URL}/players`
    if (props.tour_class) {
        url = url + `?tour_class=${tour_class}`
    }
    else if (props.t_id) {
        url = url + `?t_id=${t_id}`
    }
    const [data, setData] = useState(null);
    const [team, setTeam] = useState(null);

    const change_team = (option) => {
        setTeam(data[option]);
    };

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    });
    if (!data) {
        return <div>Loading...</div>;
    }
    let teams = Object.keys(data)
    return(
        <div className='players_page'>
            <div className='players_page_drop_down'>
                <DropdownMenu teams={teams} func={change_team}/>
            </div>
            <div className='players_page_players'>
                <PlayersBox data={team} default={data[teams[0]]} skill="bat"/>
                <PlayersBox data={team} default={data[teams[0]]} skill="wk"/>
                <PlayersBox data={team} default={data[teams[0]]} skill="all"/>
                <PlayersBox data={team} default={data[teams[0]]} skill="bow"/>
            </div>

        </div>
        // <App></App>

    );

}

export default PlayersPage;
