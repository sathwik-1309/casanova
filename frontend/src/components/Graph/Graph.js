import { Chart as ChartJS } from 'chart.js/auto';
import { Chart } from 'react-chartjs-2';
import React, { useRef, useEffect } from 'react';
import { Line } from 'react-chartjs-2';
import './Graph.css';
import { team_colors } from "./team_colors.js";

function Graph(props) {
    const chartRef = useRef(null);
    const data1 = props.data1;
    const data2 = props.data2;
    const color1 = team_colors[props.team1] || 'red';
    const color2 = team_colors[props.team2] || 'blue';
    const highlightPoints1 = props.highlightPoints1 || [];
    const highlightPoints2 = props.highlightPoints2 || [];

    const chartData = {
        labels: data1.map((_, index) => index),
        datasets: [
            {
                label: props.label1,
                data: data1,
                fill: false,
                borderColor: color1,
                backgroundColor: color1,
                pointRadius: 0,
            },
            {
                label: props.label2,
                data: data2,
                fill: false,
                borderColor: color2,
                backgroundColor: color2,
                pointRadius: 0,
            },
        ],
    };

    const chartOptions = {
        scales: {
            x: {
                beginAtZero: true,
                grid: {
                    display: false,
                },
            },
            y: {
                grid: {
                    color: '#e0e0e0',
                },
                ticks: {
                    font: {
                        size: 12,
                    },
                    callback: (value) => `${value}`,
                },
            },
        },
        plugins: {
            tooltip: {
                callbacks: {
                    label: (context) => {
                        const datasetIndex = context.datasetIndex;
                        const index = context.dataIndex;
                        const value = context.dataset.data[index];
                        return `${chartData.datasets[datasetIndex].label}: ${value}%`;
                    },
                },
            },
        },
        legend: {
            display: true,
            labels: {
                font: {
                    size: 12,
                },
            },
            onClick: (e) => e.stopPropagation(),
        },
        responsive: true,
        maintainAspectRatio: false,
    };

    const chartPlugins = [
        {
            id: 'highlightPoints',
            afterDraw: (chart) => {
                const ctx = chart.ctx;
                const meta1 = chart.getDatasetMeta(0);
                const meta2 = chart.getDatasetMeta(1);

                ctx.save();

                meta1.data.forEach((element, index) => {
                    if (highlightPoints1.includes(index)) {
                        const x = element.x;
                        const y = element.y;
                        const radius = 5;
                        const borderWidth = 2;

                        ctx.beginPath();
                        ctx.arc(x, y, radius, 0, 2 * Math.PI);
                        ctx.fillStyle = color1;
                        ctx.fill();
                        ctx.lineWidth = borderWidth;
                        ctx.strokeStyle = color1;
                        ctx.stroke();
                        ctx.closePath();
                    }
                });

                meta2.data.forEach((element, index) => {
                    if (highlightPoints2.includes(index)) {
                        const x = element.x;
                        const y = element.y;
                        const radius = 5;
                        const borderWidth = 2;

                        ctx.beginPath();
                        ctx.arc(x, y, radius, 0, 2 * Math.PI);
                        ctx.fillStyle = color2;
                        ctx.fill();
                        ctx.lineWidth = borderWidth;
                        ctx.strokeStyle = color2;
                        ctx.stroke();
                        ctx.closePath();
                    }
                });

                ctx.restore();
            },
        },
    ];

    useEffect(() => {
        // Destroy the chart instance when the component unmounts
        return () => {
            if (chartRef.current && chartRef.current.chartInstance) {
                chartRef.current.chartInstance.destroy();
            }
        };
    }, []);

    return (
        <div className="graph">
            <Line
                data={chartData}
                options={chartOptions}
                plugins={chartPlugins}
                ref={chartRef}
            />
        </div>
    );
}

export default Graph;
