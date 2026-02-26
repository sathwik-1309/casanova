import kkr from './../../../assets/logos/kkr.png'
import srh from './../../../assets/logos/srh.png'
import mi from './../../../assets/logos/mi.png'
import rcb from './../../../assets/logos/rcb.png'
import csk from './../../../assets/logos/csk.png'
import gt from './../../../assets/logos/gt.png'
import rr from './../../../assets/logos/rr.png'
import dc from './../../../assets/logos/dc.png'
import pbks from './../../../assets/logos/pbks.png'
import lsg from './../../../assets/logos/lsg.png'
import kxip from './../../../assets/logos/kxip.png'
import dch from './../../../assets/logos/dch.png'
import dd from './../../../assets/logos/dd.png'
import rpsg from './../../../assets/logos/rpsg.png'
import gl from './../../../assets/logos/gl.png'
import ktk from './../../../assets/logos/ktk.png'
import pwi from './../../../assets/logos/pwi.png'
import ind from './../../../assets/logos/ind.png'
import pak from './../../../assets/logos/pak.png'
import aus from './../../../assets/logos/aus.png'
import nz from './../../../assets/logos/nz.png'
import eng from './../../../assets/logos/eng.png'
import sl from './../../../assets/logos/sl.png'
import sa from './../../../assets/logos/sa.png'
import ban from './../../../assets/logos/ban.png'
import afg from './../../../assets/logos/afg.png'
import wi from './../../../assets/logos/wi.png'
import ned from './../../../assets/logos/ned.png'
import zim from './../../../assets/logos/zim.png'
import ire from './../../../assets/logos/ire.png'
import nam from './../../../assets/logos/nam.png'
import sco from './../../../assets/logos/sco.svg'
import uae from './../../../assets/logos/uae.png'


function Logo({team, height, width}) {
    height = 0.75*height
    let new_width = width ? width : height
    const logo_dict = {
        'kkr': kkr,
        'rcb': rcb,
        'mi': mi,
        'pbks': pbks,
        'gt': gt,
        'rr': rr,
        'lsg': lsg,
        'csk': csk,
        'srh': srh,
        'dc': dc,
        'kxip': kxip,
        'dch': dch,
        'dd': dd,
        'ind': ind,
        'pak': pak,
        'aus': aus,
        'nz': nz,
        'eng': eng,
        'sa': sa,
        'sl': sl,
        'ban': ban,
        'afg': afg,
        'wi': wi,
        'ire': ire,
        'zim': zim,
        'ned': ned,
        'sco': sco,
        'uae': uae,
        'nam': nam,
        'rpsg': rpsg,
        'gl': gl,
        'ktk': ktk,
        'pwi': pwi
    }

    const height_ratio = {
      'kkr': 1.2,
      'srh': 1.2,
      'lsg': 1.3,
      'rcb': 1.1,
      'dc': 1.15,
      'pbks': 1.2,
      'mi': 0.85,
      'csk': 1.1,
      'kxip': 1.2,
      'dch': 1.1,
      'pwi': 1.05,
      'rpsg': 0.75,
      'gl': 1.3,
      'aus': 1.15,
      'ind': 1.15,
      'pak': 1.1,
      'nz': 1.4,
      'eng': 1.35,
      'afg': 1.1,
      'sl': 1.4,
      'wi': 1.15,
      'ban': 1.2,
      'sa': 1.1
    }

    let logo_height = height

    let rounded = true

    if (height_ratio[team]){
      logo_height = height_ratio[team]*height
    }

    let img = logo_dict[team] ? logo_dict[team] : ''
    const  img_style={
      objectFit: 'cover',
      height: `${logo_height}px`,
      filter: "drop-shadow(1px 1px 1px rgba(0,0,0,0.3))"
    }
    return (
        <div className={`flex-centered`} style={{width: `${new_width}px`}}>
            <img src={img} style={img_style} className={`flex-centered`}/>
        </div>
    )
}

export default Logo