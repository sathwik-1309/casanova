import { React, useState, useEffect} from 'react'
import { BACKEND_API_URL, FRONTEND_API_URL } from '../../my_constants';
import { useParams } from 'react-router-dom';
import Photocard from '../../components/Player/Photocard/Photocard';
import axios from 'axios';

function PoolPlayerBox({player, color, select, action, display}){

  
  return (
    <div className={`w-330 flex-row h-50 bg-shadow mt-1 font-600 font-0_9 rounded-3`} onClick={()=>{select(player.p_id, action)}}>
      <Photocard p_id={player.p_id} height='50px' color={color}/>
      <div className={`${color}1 w-200 pl-10 h-50 vert-align flex font-600`}>{player.fullname_title}</div>
      <div className={`${color}1 opacity-9 w-80 font-0_8 font-500 flex-centered h-50`}>{player[display] == 1000 ? '': player[display]}</div>
    </div>
  )
}

function DisplayBox({label, display, handleClick={handleClick}}) {
  return (
    <div className={`${display==label? 'bg-black c-white' : 'border-black c-black'} h-30 pl-10 pr-10 flex-centered font-0_7 font-500 rounded-2 mt-10`} onClick={()=>{handleClick(label)}}>{label}</div>
  )
}

function PoolBoxItem({data, header, color, select, action, pool}){
  const [display, setDisplay] = useState('description')
  const [displayData, setDisplayData] = useState(data.players)
  const handleClick = (temp) => {
    setDisplay(temp)
    if (display != 'description') {
      let sortedData = [...displayData].sort((a, b) => {
        if (display=='runs' || display=='avg'||display=='sr' || display=='wickets'){
          return b[display] - a[display];
        }else {
          return a[display] - b[display];
        }
        
      });
      setDisplayData(sortedData)
    }
  }
  let block
  if (header=='Batsmen'){
    block = <div className='flex-col'>
      <DisplayBox label='description' display={display} handleClick={handleClick}/>
      <DisplayBox label='runs' display={display} handleClick={handleClick}/>
      <DisplayBox label='avg' display={display} handleClick={handleClick}/>
      <DisplayBox label='sr' display={display} handleClick={handleClick}/>
      <DisplayBox label='top_csl_rank' display={display} handleClick={handleClick}/>
      <DisplayBox label='top_wt20_rank' display={display} handleClick={handleClick}/>
    </div>
  }else if (header=='Bowlers'){
    block = <div className='flex-col'>
      <DisplayBox label='description' display={display} handleClick={handleClick}/>
      <DisplayBox label='runs' display={display} handleClick={handleClick}/>
      <DisplayBox label='wickets' display={display} handleClick={handleClick}/>
      <DisplayBox label='economy' display={display} handleClick={handleClick}/>
      <DisplayBox label='bow_sr' display={display} handleClick={handleClick}/>
      <DisplayBox label='top_csl_rank' display={display} handleClick={handleClick}/>
      <DisplayBox label='top_wt20_rank' display={display} handleClick={handleClick}/>
    </div>
  }else {
    block = <div className='flex-col'>
      <DisplayBox label='description' display={display} handleClick={handleClick}/>
      <DisplayBox label='runs' display={display} handleClick={handleClick}/>
      <DisplayBox label='avg' display={display} handleClick={handleClick}/>
      <DisplayBox label='sr' display={display} handleClick={handleClick}/>
      <DisplayBox label='wickets' display={display} handleClick={handleClick}/>
      <DisplayBox label='economy' display={display} handleClick={handleClick}/>
      <DisplayBox label='bow_sr' display={display} handleClick={handleClick}/>
      <DisplayBox label='top_csl_rank' display={display} handleClick={handleClick}/>
      <DisplayBox label='top_wt20_rank' display={display} handleClick={handleClick}/>
    </div>
  }
  return (
    <div className='flex-col w-330 vert-align mt-10 ml-10 mr-10'>
      
      <div className=''>{header}</div>
      <div>{data.count}</div>
      {
        displayData.map((player, index)=>{
          return (<PoolPlayerBox player={player} color={color} select={select} action={action} display={display}/>)
        })
      }
      {
        pool != 'Selected' && block
      }
    </div>
  )
}

function PoolBox({data, color, header, select}) {
  return (
    <div className="bg-shadow bg-white p-10 flex-col flex-centered mt-10 m-50 pb-10">
      <div className='font-1 font-600 flex-centered h-35 bg-black c-white w-200 mt-10'>{header} Players</div>
      <div className=''>Total - {data.total}</div>
      <div className='flex-row'>
        <PoolBoxItem data={data.batsmen} header='Batsmen' color={color} select={select} action={header} pool={header}/>
        <PoolBoxItem data={data.all_rounders} header='All Rounders' color={color} select={select} action={header} pool={header}/>
        <PoolBoxItem data={data.bowlers} header='Bowlers' color={color} select={select} action={header} pool={header}/>
      </div>
    </div>
  )
}

export function SelectSquads () {
  let {team_id} = useParams()
  let {pools} = useParams()
  const [data, setData] = useState(null);
  const [reload, setReload] = useState(1)
  const [pool, setPool] = useState(pools == 'pool' ? true : false)

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(`${BACKEND_API_URL}/teams/select_squads/${team_id}`);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, [reload]);
    if (!data) {
        return <div>Loading...</div>;
    }
  const handleSelect = async (p_id, action) => {
    
    const formData = {
      player_id: p_id,
      add: action == 'Selected' ? false : true
    }
    console.log(formData.action)
    const response = await axios.put(`${BACKEND_API_URL}/teams/${team_id}/select_squads_action`,formData,{ withCredentials: true })
    if (response.status === 202) {
        console.log(response.data.message);
    }else if (response.status === 200) {
        window.location.reload()
    }
  }
  const handleClick = (type) => {
    window.location.replace(`${FRONTEND_API_URL}/select_squads/${team_id}/${type}`)
  }
  return (
    <div className='font-1 font-600 default-font flex-col vert-align'>
      <PoolBox data={data.selected} color={data.color} header='Selected' select={handleSelect}/>
      <div className='bg-white flex-row flex-centered w-300 h-50 bg-shadow'>
        <div className={`w-100 font-0_9 font-500 flex-centered h-30 rounded-3 mr-10 ml-10 ${pool ? 'bg-black c-white' : 'border-black c-black'}`} onClick={()=>handleClick('pool')}>Pool</div>
        <div className={`w-100 font-0_9 font-500 flex-centered h-30 rounded-3 mr-10 ml-10 ${pool ? 'border-black c-black' : 'bg-black c-white'}`} onClick={()=>handleClick('unselected')}>Unselected</div>
      </div>  
      {
        pool ? 
        <PoolBox data={data.pool} color={data.color} header='Pool' select={handleSelect}/>
        :
        <PoolBox data={data.unselected} color='nz' header='Unselected' select={handleSelect}/>
      }
      
    </div>
  )
}

export default SelectSquads