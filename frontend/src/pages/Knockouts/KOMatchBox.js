function KOMatchBox ({match}) {
  return (
    <div className={`flex-col default-font rounded-1`}>
      <div className='bg-white c-black flex-row w-260 h-25 font-600 font-0_9 bg-shadow'>
        <div className='w-130 flex-centered'>{match.stage}</div>
        <div className='w-130 flex-centered font-0_8 font-500'>{match.venue}</div>
        
      </div>
      <KOInn data={match.inn1}/>
      <KOInn data={match.inn2}/>
      <div className={`h-24 mt-1 font-0_8 font-600 flex-centered ${match.result_color}1`}>{match.result}</div>
    </div>
  )
}

function KOInn({data}) {
  return (
    <div className={`h-40 font-1 font-600 bg-shadow flex flex-row `}>
      <div className={`h-40 w-160 pl-20 vert-align flex ${data.color}1`}>{data.teamname_full}</div>
      <div className={`w-20 font-1_2 flex-centered h-40 ${data.color}1`}>{data.won ? "⭐️" : ""}</div>
      <div className={`${data.color}1 h-40 w-80 flex-centered font-700`}>{data.score2}</div>
    </div>
  )
}
export default KOMatchBox