import React, {Component} from 'react';
import './PieChart.css'
import Slice from './Slice';

// <PieChart
//     data={data}
//     radius={100}
//     hole={0}
//     colors={colors}
//     labels={true}
//     percent={true}
//     strokeWidth={0}
//     stroke={'#fff'}
// />

export default class PieChart extends Component {
    render() {
        let {colors, labels, hole, radius, data, percent, stroke, strokeWidth} = this.props;
        let colorsLength = colors.length;
        let diameter = radius * 2;
        let sum, startAngle, d = null;
        sum = data.reduce((carry, current) => (
            carry +current
        ), 0);
        startAngle = 0;

        return (
            <div className='default-font pie_chart'>
                <svg width={ diameter } height={ diameter } viewBox={ '0 0 ' + diameter + ' ' + diameter } >
                    { data.map(function (slice, sliceIndex) {
                        let angle, nextAngle, percent;

                        nextAngle = startAngle;
                        angle = (slice / sum) * 360;
                        percent = (slice / sum) * 100;
                        startAngle += angle;

                        return <Slice
                            key={ sliceIndex }
                            value={ slice }
                            percent={ percent }
                            percentValue={ percent.toFixed(1) }
                            startAngle={ nextAngle }
                            angle={ angle }
                            radius={ radius }
                            hole={ radius - hole }
                            trueHole={ hole }
                            showLabel= { labels }
                            fill={ colors[sliceIndex % colorsLength] }
                            stroke={ stroke }
                            strokeWidth={ strokeWidth }
                        />
                    }) }

                </svg>
            </div>
        );
    }
}

