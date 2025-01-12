import React, { Component } from "react";
import logo from "./logo.svg";
import "./App.css";

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React! - Change Title v2</h1>
        </header>
        <p className="App-intro">
          Tugas submission Dicoding - CICD menggunakan jenkins (localhost) dan
          React app (AWS) - Revisi 2
        </p>
      </div>
    );
  }
}

export default App;
