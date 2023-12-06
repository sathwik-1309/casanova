import {useParams} from "react-router-dom";
import {BACKEND_API_URL} from "../../../my_constants";
import {React, useEffect, useState} from "react";
import PlayerPerfBox from "../../../components/Player/PlayerPerfBox/PlayerPerfBox";
import './PlayerPerfPage.css'
import ControlBox from "../../../components/Player/Stats/ControlBox/ControlBox";

function PlayerPerfPage(props) {
    let { p_id } = useParams();
    const base_url = `${BACKEND_API_URL}/player/${p_id}/${props.type}`
    const [url, setUrl] = useState(base_url);
    const [data, setData] = useState(null);
    const [data1, setData1] = useState(null);
    const [filter, setFilter] = useState('match_id')

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(url);
            const jsonData = await response.json();
            setData(jsonData);
            setData1(jsonData[props.type])
        };

        fetchData();
    }, [url]);

    const change_url = (url) => {
        setUrl(url)
    }

    const handleFilter = (val) => {
        setFilter(val)
        if (val=='wickets'){
            setData1(data1.sort(function(a, b) {
                const key1 = b[val] - a[val]
                return key1 !== 0 ? key1 : a['runs'] - b['runs']
              }))
        }else if (val=='match_id'){
            setData1(data1.sort(function(a, b) {
                return a[val] - b[val]
              }))
        }else if (val=='points'){
            setData1(data1.sort(function(a, b) {
                return b[val] - a[val]
              }))
        }else if (val=='economy'){
            setData1(data1.sort(function(a, b) {
                const key1 = a[val] - b[val]
                return key1 !== 0 ? key1 : b['wickets'] - a['wickets']
              }))
        }else if (val=='runs'){
            setData1(data1.sort(function(a, b) {
                const key1 = b[val] - a[val]
                return key1 !== 0 ? key1 : b['sr'] - a['sr']
              }))
        }else if (val=='sr'){
            setData1(data1.sort(function(a, b) {
                const key1 = b[val] - a[val]
                return key1 !== 0 ? key1 : b['runs'] - a['runs']
              }))
        }

    }

    if (!data) {
        return <div>Loading...</div>;
    }
    
    return (
        <div className='player_scores_page flex-col gap-60 default-font'>
            <ControlBox base_url={base_url} stat_options={data.stat_options} func={change_url}/>
            <div className='flex-row w-600 wrap gap-50 flex-centered h-70 bg-white bg-shadow rounded-4 mt-10'>
                <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${filter == 'match_id' ? 'display_select' : 'display_unselect'}`} onClick={()=>{handleFilter('match_id')}}>Match</div>
                <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${filter == 'points' ? 'display_select' : 'display_unselect'}`} onClick={()=>{handleFilter('points')}}>Points</div>
                {
                    props.type == 'spells' ?
                    <div className="flex-row gap-50">
                        <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${filter == 'wickets' ? 'display_select' : 'display_unselect'}`} onClick={()=>{handleFilter('wickets')}}>Wickets</div>
                        <div className={`h-30 w-80 flex-centered p-5 font-600 font-0_8 rounded-4 ${filter == 'economy' ? 'display_select' : 'display_unselect'}`} onClick={()=>{handleFilter('economy')}}>Economy</div>
                    </div> :
                    <div className="flex-row gap-50">
                        <div className={`h-30 w-80 flex-centered font-600 font-0_8 rounded-4 ${filter == 'runs' ? 'display_select' : 'display_unselect'}`} onClick={()=>{handleFilter('runs')}}>Runs</div>
                        <div className={`h-30 w-80 flex-centered p-5 font-600 font-0_8 rounded-4 ${filter == 'sr' ? 'display_select' : 'display_unselect'}`} onClick={()=>{handleFilter('sr')}}>Strike-rate</div>
                    </div>
                }
            </div>
            <div className="flex-col gap-50">
                {
                    data1.map((player)=>{
                        return <PlayerPerfBox data={player} type={props.type} sub_type='2'/>
                    })
                }
                
            </div>
            
        </div>
    );
}

export default PlayerPerfPage
