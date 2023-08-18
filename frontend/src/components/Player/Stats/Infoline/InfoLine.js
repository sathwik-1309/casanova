function InfoLine(props) {
    let class1 = `bs_info_line_label flex-centered ${props.color}2 w-90`
    if (props.bold) {
        class1 = class1 + ' font-600'
    }
    return (
        <div className='bs_info_line h-35 flex-row'>
            <div className={`bs_info_line_label flex vert-align lp-15 ${props.color}1 w-140 font-0_9`}>{props.label}</div>
            <div className={class1}>{props.value}</div>
        </div>
    );
}

export default InfoLine
