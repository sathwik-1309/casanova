import { React, useState, useEffect} from 'react'
import { BACKEND_API_URL, FRONTEND_API_URL } from '../../my_constants';

function SelectSquadsBox ({data}) {
  return (
    <a className={`font-1 font-600 default-font flex-row mt-10 ml-10 mr-10 bg-shadow rounded-2 mb-10 decoration-none`} href={`/select_squads/${data.id}/pool`}>
      <div className={`w-300 w-60 ${data.color}1 h-50 flex-centered`}>{data.teamname}</div>
      <div className={`flex-centered w-60 ${data.color}1 opacity-9 h-50`}>{data.selected_players}</div>
    </a>
  )
}


function SelectSquadsPage() {
  const [data, setData] = useState(null);

    useEffect(() => {
        const fetchData = async () => {
            const response = await fetch(`${BACKEND_API_URL}/teams/select_squads`);
            const jsonData = await response.json();
            setData(jsonData);
        };

        fetchData();
    }, []);
    if (!data) {
        return <div>Loading...</div>;
    }
    return (
        
        <div className="" style={{
          display: 'flex',
          margin: '50px',
          flexWrap: 'wrap',
          alignItems: 'center',
          justifyContent: 'center'
        }}>
            {
              data.map((team, index)=>{
                return <SelectSquadsBox data={team} key={index}/>
              })
            }
        </div>
        )

    }
export default SelectSquadsPage;
