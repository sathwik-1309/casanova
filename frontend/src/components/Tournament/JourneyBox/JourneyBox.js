import './JourneyBox.css'
function JourneyBox(props) {
    const journey = props.journey
    return (
        <div className='journey_box'>
            {journey.map((result, index) => (
                <JourneyItem key={index} data={result}/>
            ))}
        </div>
    )

}

function JourneyItem(props) {
    const data = props.data
    let color = data.won ? 'green' : 'red'
    return (
        <div className={`journey_item ${color}`}>
            <div className='journey_vs_team'>v {data.vs_team}</div>
            <div className={`journey_item_result`}>{data.result}</div>
        </div>
    );
}

export default JourneyBox;