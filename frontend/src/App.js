import {
  BrowserRouter as Router,
  Routes,
  Route,
} from "react-router-dom";
import React from 'react';
import HomePage from "./pages/HomePage/HomePage";
import MatchPage from "./pages/MatchPage/MatchPage";
import WebPage from "./pages/WebPage/WebPage";
import TournamentPage from "./pages/TournamentPage/TournamentPage";
import PlayerPage from "./pages/PlayerPage/PlayerPage";
import MatchesPage from "./pages/MatchesPage/MatchesPage";
import './components/css/teams.css'
import './common.css'
import TournamentsPage from "./pages/TournamentsPage/TournamentsPage";
import PlayersPage from "./pages/PlayersPage/PlayersPage";
import TeamsPage from "./pages/TeamsPage/TeamsPage";
import VenuesPage from "./pages/VenuesPage/VenuesPage";
import TournamentHome from "./pages/TournamentPage/TournamentHome/TournamentHome";
import Meta from "./components/Meta/Meta";
import CreateTournament from "./pages/Create/Tournament/CreateTournament";


function App() {
  return (

  <Router>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin/>
    <link
            href="https://fonts.googleapis.com/css2?family=Audiowide&family=Karla:ital,wght@0,400;0,500;0,600;1,400;1,500;1,600&family=Lato:ital,wght@0,100;0,300;0,400;0,700;0,900;1,100;1,300;1,400;1,700;1,900&family=Lexend:wght@400;500;600&family=Montserrat:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&family=Noto+Sans+JP:wght@400;500;600;700&family=Open+Sans:ital,wght@0,300;0,400;0,500;0,600;0,700;0,800;1,300;1,400;1,500;1,600;1,700;1,800&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Wix+Madefor+Text:ital,wght@0,400;0,500;0,600;0,700;1,400;1,500;1,600;1,700&display=swap"
            rel="stylesheet"/><link/>
    <Routes>
      <Route path="/" element={<WebPage page={<HomePage/>} s_id='home'/>} />

      <Route path="/meta/batting" element={<WebPage page={<Meta type={`batting`}/>} s_id='home'/>} />
      <Route path="/meta/bowling" element={<WebPage page={<Meta type={`bowling`}/>} s_id='home'/>} />

      <Route path="/tournament/:t_id" element={<WebPage page={<TournamentHome/>} s_id='tour' />}/>
      <Route path="/tournament/:t_id/matches" element={<WebPage page={<MatchesPage t_id={true}/>} s_id='tour' />}/>
      <Route path="/tournament/:t_id/venues" element={<WebPage page={<VenuesPage t_id={true}/>} s_id='tour' />}/>
      <Route path="/tournament/:t_id/teams" element={<WebPage page={<TeamsPage t_id={true}/>} s_id='tour' />}/>
      <Route path="/tournament/:t_id/players" element={<WebPage page={<PlayersPage t_id={true}/>} s_id='tour' />}/>
      <Route path="/tournament/:t_id/:page" element={<WebPage page={<TournamentPage/>} s_id={'tour'}/>} />

      <Route path="/tournaments/:tour_class" element={<WebPage page={<TournamentsPage/>} s_id='tour_class'/>} />
      <Route path="/tournaments/:tour_class/matches" element={<WebPage page={<MatchesPage tour_class={true}/>} s_id='tour_class' />}  />
      <Route path="/tournaments/:tour_class/venues" element={<WebPage page={<VenuesPage tour_class={true}/>} s_id='tour_class' />}  />
      <Route path="/tournaments/:tour_class/teams" element={<WebPage page={<TeamsPage tour_class={true}/>} s_id='tour_class' />}  />
      <Route path="/tournaments/:tour_class/players" element={<WebPage page={<PlayersPage tour_class={true}/>} s_id='tour_class' />}  />

      <Route path="/teams" element={<WebPage page={<TeamsPage/>}/>}  />

      <Route path="/venues" element={<WebPage page={<VenuesPage/>}/>}  />

      <Route path="/match/:m_id/:inn_no/:graphic" element={<WebPage page={<MatchPage/>} s_id='match'/>}/>

      <Route path="/player/:p_id/:page" element={<WebPage page={<PlayerPage/>}/>} />

      <Route path="/players" element={<WebPage page={<PlayersPage/>} s_id='players_page'/>} />

      <Route path="/matches" element={<WebPage page={<MatchesPage/>}/>}  />

      <Route path="/create/tournament" element={<WebPage page={<CreateTournament/>}/>}  />



    </Routes>
  </Router>
  );
}

export default App;
