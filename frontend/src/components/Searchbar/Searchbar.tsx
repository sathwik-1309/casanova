import React, { ChangeEvent, useState, useEffect} from "react";
import './Searchbar.css'
import { BACKEND_API_URL } from './../../my_constants'

function SearchbarSuggestion(props) {
    let data = props.data
    return (
        <a className='sb_suggestion h-30 flex vert-align' href={`http://localhost:3000/player/${data.id}`}>{data.name}</a>
    );
}

function Searchbar(props) {
    const [seachtext, setSearchText] = useState('')
    const [suggestions, setSuggestions] = useState([])
    const handleChange = (e:ChangeEvent<HTMLInputElement>) => {
        setSearchText(e.target.value);
        search(e.target.value);
    }
    const search = async (text: string) => {
        const response = await fetch(`${BACKEND_API_URL}/search/player?pattern=${seachtext}`);
        const result = await response.json();
        setSuggestions(result);
        console.log(result);
    }

    let sbox = <></>
    if (seachtext) {
        sbox = <>{suggestions && suggestions.map(item =>
            <SearchbarSuggestion data={item}/>)
            }
            </>
    }
    else {
        sbox = <></>
    }

    return (
        <div className='searchbar w-320 font-400 relative'>
            <input type="text" className='searchbar_main h-35 font-1' onChange={handleChange}></input>
            <div className='searchbar_suggestions font-0_9 absolute bg-white w-300'>
                {sbox}
            </div>
        </div>

    );
}

export default Searchbar;
