import React, {useState, useEffect} from 'react'
import { useParams } from 'react-router-dom'
import { BACKEND_API_URL } from '../../../my_constants'
import HeadtoHeadBox from '../../../components/Team/HeadtoHeadBox/HeadtoHeadBox'
import { HeadtoHeadDetailed } from '../../../components/Team/HeadtoHeadDetailed/HeadtoHeadDetailed'
import './HeadtoHead.css'
import PreMatch from '../../../components/Match/PreMatch/PreMatch'

export function HeadtoHead(props) {
  let {team_id} = useParams()
  let {squad_id} = useParams()
  
  let url
  if (props.team_id){
    url = `${BACKEND_API_URL}/teams/head_to_head?team_id=${team_id}`
  }else {
    url = `${BACKEND_API_URL}/teams/head_to_head?squad_id=${squad_id}`
  }
  const [data, setData] = useState(null);
  const [team2, setTeam2] = useState(null)
  const [team1, setTeam1] = useState(null)

  useEffect(() => {
      const fetchData = async () => {
          const response = await fetch(url);
          const jsonData = await response.json();
          setData(jsonData);
          setTeam1(jsonData.team_id)
          console.log(jsonData)
      };

      fetchData();
  }, [])

  const changeTeam2 = (id) => {
    console.log(id)
    console.log('change')
    setTeam2(id)
  }

  if (!data) {
      return <div>Loading...</div>;
  }
  
  return (
    <div className='flex-row h2hparent'>
      <HeadtoHeadBox data={data.head_to_head} onClick={changeTeam2}/>
      {
        team2 &&
        // <HeadtoHeadDetailed team1={team1} team2={team2}/>
        <PreMatch team1={team1} team2={team2} />
      }
    </div>
  )
}
