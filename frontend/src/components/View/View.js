import React, { useState, useEffect, useParams } from 'react';
import axios from 'axios';
import './View.css';

function View(props) {
  let name = props.match.params.name;

  const [info, setInfo] = useState([]);
  const [isLoading, setLoading] = useState(false);

  async function getInfo() {
    const url = `https://52773-1-f1491bcb.try.learning.intersystems.com/api/interballing/players/${name}`
    const response = await axios.get(url);
    const playerInfo = response.data.items;
    setInfo(playerInfo);
  }

  useEffect(async () => {
    console.log('name', name);
    setLoading(true);
    getInfo();
    setLoading(false);
  }, []);

  if (isLoading) {
    return (<div>Loading dashboard...</div>);
  }

  return (
    <div>
      <h2>{name.replace("_", " ")}</h2>
      <table class="styled-table">
        <tr>
          <th>Season</th>
          <th>Team</th>
          <th>Games Played</th>
          <th>Minutes Played / G</th>
          <th>Field Goals Made / G</th>
          <th>Field Goals Attempted / G</th>
          <th>Field Goal Percentage</th>
          <th>3 Pointers Made / G</th>
          <th>3 Pointers Attempted / G</th>
          <th>3 Pointer Percentage</th>
          <th>Free Throws Made / G</th>
          <th>Free Throws Attempted / G</th>
          <th>Free Throw Percentage</th>
          <th>Offensive Rebounds / G</th>
          <th>Defensive Rebounds / G</th>
          <th>Total Rebounds / G</th>
          <th>Assists / G</th>
          <th>Turnovers / G</th>
          <th>Steals / G</th>
          <th>Blocks / G</th>
          <th>Personal Fouls / G</th>
          <th>Points / G</th>
        </tr>
      { info.map((el) => {
        return (
          <tr>
          <td>{el.season_id}</td>
          <td>{el.team_abbreviation}</td>
          <td>{el.gp}</td>
          <td>{(el.mp/el.gp).toFixed(2)}</td>
          <td>{(el.fgm/el.gp).toFixed(2)}</td>
          <td>{(el.fga/el.gp).toFixed(2)}</td>
          <td>{el.fg_pct}</td>
          <td>{(el.fg3m/el.gp).toFixed(2)}</td>
          <td>{(el.fg3a/el.gp).toFixed(2)}</td>
          <td>{el.fg3_pct}</td>
          <td>{(el.ftm/el.gp).toFixed(2)}</td>
          <td>{(el.fta/el.gp).toFixed(2)}</td>
          <td>{el.ft_pct}</td>
          <td>{(el.oreb/el.gp).toFixed(2)}</td>
          <td>{(el.dreb/el.gp).toFixed(2)}</td>
          <td>{(el.reb/el.gp).toFixed(2)}</td>
          <td>{(el.ast/el.gp).toFixed(2)}</td>
          <td>{(el.tov/el.gp).toFixed(2)}</td>
          <td>{(el.stl/el.gp).toFixed(2)}</td>
          <td>{(el.blk/el.gp).toFixed(2)}</td>
          <td>{(el.pf/el.gp).toFixed(2)}</td>
          <td>{(el.pts/el.gp).toFixed(2)}</td>
          </tr>
        )
      })}
      </table>
      
    </div>
  );
}

export default View;
