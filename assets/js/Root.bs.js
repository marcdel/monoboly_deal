'use strict';

var Game = require("./Game.bs.js");
var ReactDOMRe = require("reason-react/src/ReactDOMRe.js");
var ReasonReact = require("reason-react/src/ReasonReact.js");

ReactDOMRe.renderToElementWithId(ReasonReact.element(undefined, undefined, Game.make(window.GameName, /* array */[])), "game-root");

/*  Not a pure module */
