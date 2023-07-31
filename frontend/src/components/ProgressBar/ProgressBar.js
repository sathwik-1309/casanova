import React from 'react';

function ProgressBar(props) {
    const {
        progress,
        label,
        height = 20,
        width = 300,
        color1 = '#0259e6',
        color2 = '#edeff2',
    } = props;

    const progressStyles = {
        height: `${height}px`,
        width: `${width}px`,
        background: `linear-gradient(to right, ${color1} ${progress}%, ${color2} ${progress}%)`,
        borderRadius: '5px',
        overflow: 'hidden',
        position: 'relative',
    };

    const labelStyles = {
        position: 'absolute',
        top: 0,
        right: '2px',
        height: '100%',
        display: 'flex',
        alignItems: 'center',
        paddingRight: '2px',
        fontSize: '0.9rem',
        fontWeight: 500,
        color: 'black',
    };

    return (
        <div style={progressStyles}>
            <div className="progress-bar__fill" style={{ width: `${progress}%` }}></div>
            <div style={labelStyles}>{label}</div>
        </div>
    );
}

export default ProgressBar;
