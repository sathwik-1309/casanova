import React from 'react';
import './Worm.css'
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';

const Worm = ({ data1, data2, color1 = 'blue', color2 = 'red' }) => {
    return (
        <LineChart width={800} height={600} data={data1.concat(data2)}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="x" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Line type="monotone" dataKey="y" stroke={color1} activeDot={{ r: 8 }} />
            <Line type="monotone" dataKey="y" stroke={color2} activeDot={{ r: 8 }} />
        </LineChart>
    );
};

export default Worm;
