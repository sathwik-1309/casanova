import './SummaryHeader.css'

function SummaryHeader(props) {
    let header = props.header

    return (
        <div className="summary_header">
            <div className='summary_header_items'>
                {header.title1}
            </div>
            <div className='summary_header_items'>
            {header.title2}
            </div>
            <div className='summary_header_items'>
            {header.title3}
            </div>
        </div>
    )

    }
export default SummaryHeader;