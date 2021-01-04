import logo from './logo.svg';
import './App.css';
import Main from './components/Main';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Online Test
        </p>
      </header>
      <Main />
      <footer className="footer">
        Copy right @SM IT Consultant Ltd
      </footer>
    </div>
  );
}

export default App;
