import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';
import axios from 'axios';
import Home from './components/Home/Home';
import View from './components/View/View';
import './App.css';

function App() {
  
  return (
    <div className="App">
      <Router>
        <Switch>

          <Route path="/view/:name" component={View} />
          <Route path="/" component={Home} exact />
        </Switch>
      </Router>
    </div>
  );
}

export default App;
