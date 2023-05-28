import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";
import HomePage from "./pages/HomePage/HomePage";
import MatchPage from "./pages/MatchPage/MatchPage";
import WebPage from "./pages/WebPage/WebPage";
import TournamentPage from "./pages/TournamentPage/TournamentPage";
import PlayerPage from "./pages/PlayerPage/PlayerPage";
import MatchesPage from "./pages/MatchesPage/MatchesPage";
import './components/css/teams.css'
import TournamentsPage from "./pages/TournamentsPage/TournamentsPage";


function App() {
  return (

  <Router>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
        <link
            href="https://fonts.googleapis.com/css2?family=Audiowide&family=Karla:ital,wght@0,400;0,500;0,600;1,400;1,500;1,600&family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Lexend:wght@400;500;600&family=Montserrat:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&family=Noto+Sans+JP:wght@400;500;600;700&family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Wix+Madefor+Text:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet"/><link/>
    <Routes>
      <Route path="/" element={<WebPage page={<HomePage/>}/>} />
      {/* <Route path="/tournament" element={<Tournament/>} /> */}
      <Route path="/tournament/:t_id/:page" element={<WebPage page={<TournamentPage/>}/>} />

      <Route path="/tournaments/:tour_class" element={<WebPage page={<TournamentsPage/>}/>} />

      <Route path="/match/:m_id" element={<WebPage page={<MatchPage/>}/>}  />
      <Route path="/match/:m_id/:inn_no/:graphic" element={<WebPage page={<MatchPage/>}/>}  />

      <Route path="/player/:p_id/:page" element={<WebPage page={<PlayerPage/>}/>} />

      <Route path="/matches" element={<WebPage page={<MatchesPage/>}/>}  />

    </Routes>
  </Router>
  );
}

export default App;
