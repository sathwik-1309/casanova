import React, {useState, useEffect} from 'react'
import { useParams } from 'react-router-dom'
import { BACKEND_API_URL } from '../../my_constants';
import './Knockouts.css'
import KOMatchBox from './KOMatchBox';



function Semis({matches}) {
  return (
    <div className='flex-col'>
      <div className='flex-row'>
        <KOMatchBox match={matches[0]}/>
        <div className='w-30 flex-col'>
          <div className='w-30 h-65'></div>
          <div className='w-30 h-65 rb-1 tb-1'></div>
        </div>
        <div className='w-320'></div>
        <div className='w-30 flex-col'>
          <div className='w-30 h-65'></div>
          <div className='w-30 h-65 lb-1 tb-1'></div>
        </div>
        <KOMatchBox match={matches[1]}/>
      </div>
      <div className='h-40 flex-row'>
        <div className='w-290 h-65 rb-1'></div>
        <div className='w-320'></div>
        <div className='w-290 h-65 lb-1'></div>
      </div>
      <div className='flex-row'>
        <div className='w-290 flex-col'>
          <div className='h-60 rb-1'></div>
        </div>
        <div className='w-30 flex-col'>
          <div className='h-60 bb-1'></div>
        </div>
        <KOMatchBox match={matches[2]}/>
        <div className='w-30'>
          <div className='h-65 bb-1'></div>
        </div>
        <div className='w-30 lb-1 h-65'></div>
      </div>
      

    </div>
  )
}

function Quarters({matches}) {
  return (
    <div className='flex-row'>
      <div className='flex-col'>
        <KOMatchBox match={matches[0]}/>
        <div className='h-100'></div>
        <KOMatchBox match={matches[1]}/>
      </div>
      
      <div className='w-30 flex-col'>
        <div className='h-65'></div>
        <div className='h-230 tb-1 rb-1'></div>
        <div className='tb-1 h-30'></div>
      </div>
      <div className='w-30 flex-col'>
        <div className='h-165'></div>
        <div className='h-30 tb-1'></div>
      </div>
      <div className='pt-100'>
        <Semis matches={matches.slice(-3)}/>
      </div>
      <div className='w-30 flex-col'>
        <div className='h-165'></div>
        <div className='h-30 tb-1'></div>
      </div>
      <div className='w-30 flex-col'>
        <div className='h-65'></div>
        <div className='h-230 tb-1 lb-1'></div>
        <div className='tb-1 h-30'></div>
      </div>
      
      <div className='flex-col'>
        <KOMatchBox match={matches[2]}/>
        <div className='h-100'></div>
        <KOMatchBox match={matches[3]}/>
      </div>
      
      <div></div>
    </div>
  )
}

function Knockouts () {
  let {t_id} = useParams()
  let url = `${BACKEND_API_URL}/tournament/${t_id}/knockouts`
  const [data, setData] = useState(null);

  useEffect(() => {
      const fetchData = async () => {
      const response = await fetch(url);
      const jsonData = await response.json();
      setData(jsonData);
      };

      fetchData();
  }, []);

  let block = <></>


  if (!data) {
      return <div>Loading...</div>;
    }else {
      switch (data.format){
        case 'semis':
          block = <Semis matches={data.matches}/>
          break
        case 'quarters':
          block = <Quarters matches={data.matches}/>
          break
        case 'playoffs':
          block = <Semis matches={data.matches}/>
          break
      }
    }
  return (
    <div className='p-3 mt-40'>
      {block}
    </div>
  )
}

export default Knockouts