import React, {useEffect, useState} from "react";
import './CreateTournament.css';
import { BACKEND_API_URL } from "../../../my_constants";
import { toast, ToastContainer } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';

function TournamentListItem(props) {
    let class1 = 'tournament_list_item'
    if (props.arr.includes(props.data.t_id)) {
        class1 = class1 + ' tf_selected'
    }
    return (
        <div className={class1} onClick={() => props.func(props.data.t_id)}>{props.data.name}</div>
    );
}

function TournamentList(props) {
    let url = `${BACKEND_API_URL}/tournament/list`
    const [data, setData] = useState(null);
    const [selected, setSelected] = useState([]);

    const handleclick = (t_id) => {
        if (selected.includes(t_id)){
            setSelected( selected.filter(item => item !== t_id))
        }
        else {
            setSelected([...selected, t_id]);
        }
    };
    const delete_api = async (selected) => {
        try {
            const response = await fetch(`${BACKEND_API_URL}/tournament/delete`, {
                method: 'DELETE',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ t_ids: selected })
            });

            if (response.ok) {
                toast.success('Tournaments deleted successfully');
            } else {
                console.log(response)
                toast.error(`Failed to delete tournament : ${response.message}`);
            }
        } catch (error) {
            toast.error('Failed to delete tournament: ' + error.message);
        }
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
        <div className='tournament_list'>
            <div className='tournament_list_label'>TOURNAMENTS</div>
            <div className='tournament_list_items'>
                {data.map((tour, index) => (
                    <TournamentListItem data={tour} index={index} func={handleclick} arr={selected}/>
                ))}
            </div>
            <button className='tf_button' onClick={() => delete_api(selected)}>DELETE</button>

        </div>
    );

}

function CreateTournament(props) {
    const [name, setName] = useState('');
    const [season, setSeason] = useState('');

    const handleSubmit = async (e) => {
        e.preventDefault();

        try {
            const response = await fetch(`${BACKEND_API_URL}/tournament/create`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ name, season }),
            });

            if (response.ok) {
                toast.success('Tournament created successfully');
                setName('');
                setSeason('');
            } else {
                console.log(response)
                toast.error(`Failed to create tournament : ${response.message}`);
            }
        } catch (error) {
            toast.error('Failed to create tournament: ' + error.message);
        }
    };

    return (
        <div className='create_tour_page default-font'>
            <div className='create_tour_parent'>
                <ToastContainer />
                <form onSubmit={handleSubmit} className='tour_form'>
                    <div className='tf_field'>
                        <label className='tf_label'>NAME</label>
                        <input
                            type="text"
                            value={name}
                            onChange={(e) => setName(e.target.value)}
                        />
                    </div>
                    <button type="submit" className='tf_button'>CREATE</button>
                </form>
            </div>
            <TournamentList/>
        </div>
    );
}

export default CreateTournament;
