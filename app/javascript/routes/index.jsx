import React from "react";
import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Root from "../components/Root";

export default (
  <Router>
    <Routes>
      <Route path="/" element={<Root />} />
    </Routes>
  </Router>
);
