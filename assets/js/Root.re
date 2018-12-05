let gameName: string = [%bs.raw
  {| document.getElementById("game") ? document.getElementById("game").getAttribute("data-name") : "" |}
];

[@bs.val] external userToken: string = "window.userToken";

if (gameName != "") {
  ReactDOMRe.renderToElementWithId(<Game gameName userToken />, "game");
};
