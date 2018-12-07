import "phoenix_html"
import socket from "./socket"

import * as React from "react"
import { render } from "react-dom"
import { Game } from "./Game"

if (document.getElementById("game-root")) {
  const gameDiv = document.getElementById("game")
  const gameName = gameDiv && gameDiv.getAttribute("data-name")
  render(<Game gameName={gameName} socket={socket} />,
    document.getElementById("game-root"))
}
