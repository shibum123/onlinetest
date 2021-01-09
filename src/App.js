import logo from './logo.svg';
import React from 'react';
import './App.css';
import Main from './components/Main';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

const App = () => {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Online Test
      </p>
      </header>
      <Router>
        <Switch>
          <Route exact path="/">
            <Main />
          </Route>
        </Switch>
      </Router>
      <footer className="footer">
        Copy right @SM IT Consultant Ltd
    </footer>
    </div>
  );
}

export default App;
