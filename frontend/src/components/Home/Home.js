import React, { useState, useEffect, Link } from 'react';

import { useHistory } from 'react-router-dom';
import axios from 'axios';
import './Home.css';

function Home() {
  const history = useHistory();
  const [players, setPlayers] = useState([]);
  const [isLoading, setLoading] = useState(false);

  async function getPlayers() {
    const response = await axios.get('https://52773-1-f1491bcb.try.learning.intersystems.com/api/interballing/players');
    const playerInfo = response.data.items;
    // console.log('playerInfo', playerInfo);
    setPlayers(playerInfo);
    // console.log(players);

    // console.log(typeof players);
  }

  function redirectTo(name) {
    history.push(`/view/${name.replace(' ', '_')}`);
  }

  useEffect(async () => {
    setLoading(true);
    getPlayers();
    console.log('players in useEffect', players);
    console.log(typeof players);
    setLoading(false);
  }, []);

  if (isLoading) {
    return (<div>Loading dashboard...</div>);
  }

  return (
    <div>
      <h2>InterBalling</h2>
      <h3>Here are all the active NBA players. Click on a player's name to see their stats!</h3>
      { players.map((el, index) => {
        return (
          // <p key={index}>
          //   <a href={`/view/${el.name}`}>{el.name}</a>
          // </p>
          <p onClick={() => {redirectTo(el.name)}}>{el.name}</p>
        )
      })}
    </div>
  );
}

export default Home;
