'use strict';

var Game = require("./Game.bs.js");
var ReactDOMRe = require("reason-react/src/ReactDOMRe.js");
var ReasonReact = require("reason-react/src/ReasonReact.js");

var gameName = ( document.getElementById("game") ? document.getElementById("game").getAttribute("data-name") : "" );

if (gameName !== "") {
  ReactDOMRe.renderToElementWithId(ReasonReact.element(undefined, undefined, Game.make(gameName, window.userToken, /* array */[])), "game");
}

exports.gameName = gameName;
/* gameName Not a pure module */
