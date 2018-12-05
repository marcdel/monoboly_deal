'use strict';

var Phx = require("bucklescript-phx/src/phx.js");
var Block = require("bs-platform/lib/js/block.js");
var Curry = require("bs-platform/lib/js/curry.js");
var React = require("react");
var ReasonReact = require("reason-react/src/ReasonReact.js");

var component = ReasonReact.reducerComponent("Game");

function make(gameName, userToken, _children) {
  return /* record */[
          /* debugName */component[/* debugName */0],
          /* reactClassInternal */component[/* reactClassInternal */1],
          /* handedOffState */component[/* handedOffState */2],
          /* willReceiveProps */component[/* willReceiveProps */3],
          /* didMount */component[/* didMount */4],
          /* didUpdate */component[/* didUpdate */5],
          /* willUnmount */component[/* willUnmount */6],
          /* willUpdate */component[/* willUpdate */7],
          /* shouldUpdate */component[/* shouldUpdate */8],
          /* render */(function (self) {
              return React.createElement("div", undefined, React.createElement("h1", undefined, gameName), React.createElement("button", {
                              className: "button",
                              onClick: (function (_event) {
                                  return Curry._1(self[/* send */3], /* Deal */0);
                                })
                            }, "Deal"));
            }),
          /* initialState */(function (param) {
              var params = {
                token: userToken
              };
              var options = {
                params: params
              };
              console.log(options);
              var eta = Phx.initSocket(undefined, "/socket");
              var socket = Phx.connectSocket(undefined, eta);
              var partial_arg = "games:" + gameName;
              var gameChannel = (function (eta) {
                    var param = undefined;
                    var param$1 = eta;
                    return Phx.initChannel(partial_arg, param, param$1);
                  })(socket);
              return /* record */[
                      /* gameChannel */gameChannel,
                      /* game : record */[/* gameName */gameName]
                    ];
            }),
          /* retainedProps */component[/* retainedProps */11],
          /* reducer */(function (action, state) {
              return /* Update */Block.__(0, [state]);
            }),
          /* jsElementWrapped */component[/* jsElementWrapped */13]
        ];
}

exports.component = component;
exports.make = make;
/* component Not a pure module */
