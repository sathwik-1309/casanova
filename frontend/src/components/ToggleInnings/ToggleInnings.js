import './ToggleInnings.css'

function ToggleInnings(props) {
    let inn1 = 'ti_inn'
    let inn2 = 'ti_inn'
    const currentURL = window.location.href;
    const selected_arr = currentURL.split('/');
    selected_arr[5] = 1
    const link1 = selected_arr.join('/');
    selected_arr[5] = 2
    const link2 = selected_arr.join('/');
    
    if (props.inn_no === "1") {
        inn1 += ' ti_selected'
    }
    else {
        inn2 += ' ti_selected'
    }
    return (
        <div className="toggle_innings">
            <a className={inn1} href={link1}>
                1st Inn
            </a>
            <a className={inn2} href={link2}>
                2nd Inn
            </a>
        </div>
    );
}

export default ToggleInnings