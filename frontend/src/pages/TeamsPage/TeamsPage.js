import React, {useEffect, useState} from 'react';
import './TeamsPage.css'
import TeamBox from "../../components/Teams/TeamBox/TeamBox";
import {useParams} from "react-router-dom";
function TeamsPage(props) {
    let {tour_class} = useParams()
    let url = 'http://localhost:3001/teams'

    let initial_state = "wt20"
    if (props.tour_class) {
        url = url + `?tour_class=${tour_class}`
        initial_state = `${tour_class}`
    }

    const [data, setData] = useState(null);
    const [tourclass, settourclass] = useState(initial_state);

    const handleOptionSelect = (option) => {
        settourclass(option);
    };

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
    return (
        <div className={`teams_page default-font`}>
            {!tour_class && (
                <div>
                    <div className='teams_page_buttons'>
                        <div className={`teams_page_button_item ${tourclass == 'wt20' ? 'selected' : ''}`} onClick={() => handleOptionSelect('wt20')}>WT20</div>
                        <div className={`teams_page_button_item ${tourclass == 'ipl' ? 'selected' : ''}`} onClick={() => handleOptionSelect('ipl')}>IPL</div>
                        <div className={`teams_page_button_item ${tourclass == 'csl' ? 'selected' : ''}`} onClick={() => handleOptionSelect('csl')}>CSL</div>
                    </div>
                </div>
            )}

            <div className='teams_page_teams'>
                {data[tourclass].map((team, index) => (
                    <TeamBox data={team}/>
                ))}
            </div>
        </div>
    );

}
export default TeamsPage;
