import './Topbar.css'

function Topbar(props) {
    const inn_no = props.inn_no
    const graphic = props.graphic
    const m_id = props.m_id
    const temp = "match_topbar_item1_items "
    let temp1 = "match_topbar_white"
    let temp2 = "match_topbar_green"
    let class1 = temp + temp1
    let class2 = temp + temp2
    if (inn_no==1) {
        class1 = temp + temp2
        class2 = temp + temp1
    }
    
    const temp3 = "match_topbar_item2_items"
    const temp4 = " match_topbar_item2_white"
    let class3 = temp3
    let class4 = temp3
    let class5 = temp3
    let class6 = temp3
    let class7 = temp3
    let class8 = temp3
    switch(graphic) {
        case "summary":
            class3 = temp3 + temp4
          break;
        case "scorecard":
            class4 = temp3 + temp4
          break;
        case "fow":
            class5 = temp3 + temp4
          break;
        case "bowling_card":
            class6 = temp3 + temp4
          break;
        case "partnerships":
            class7 = temp3 + temp4
          break;
        case "manhatten":
            class8 = temp3 + temp4
          break;
        default:
            class3 = temp3 + temp4
      }

      const url1 = `http://localhost:3000/match/${m_id}/1/${graphic}`
      const url2 = `http://localhost:3000/match/${m_id}/2/${graphic}`
      const url3 = `http://localhost:3000/match/${m_id}/${inn_no}/summary`
      const url4 = `http://localhost:3000/match/${m_id}/${inn_no}/scorecard`
      const url5 = `http://localhost:3000/match/${m_id}/${inn_no}/fow`
      const url6 = `http://localhost:3000/match/${m_id}/${inn_no}/bowling_card`
      const url7 = `http://localhost:3000/match/${m_id}/${inn_no}/partnerships`
      const url8 = `http://localhost:3000/match/${m_id}/${inn_no}/manhatten`

    return (
        <div id="match_topbar">
            <div id="match_topbar_item1">
                <a className={class1} href={url1}>
                    INN I
                </a>
                <a className={class2} href={url2}>
                INN II
                </a>
            </div>
            <div id="match_topbar_item2">
                <a className={class3} href={url3}>
                    Summary
                </a>
                <a className={class4} href={url4}>
                    Scorecard
                </a>
                <a className={class5} href={url5}>
                    FOW
                </a>
                <a className={class6} href={url6}>
                    Bowling Card
                </a>
                <a className={class7} href={url7}>
                    Partnerships
                </a>
                <a className={class8} href={url8}>
                    Manhatten
                </a>
                
            </div>
        </div>
    )

    }
export default Topbar;