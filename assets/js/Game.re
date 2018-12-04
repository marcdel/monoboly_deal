let component = ReasonReact.statelessComponent("Game");
let handleClick = (_event, _self) => Js.log("Game name clicked.");
let make = (~gameName, _children) => {
  ...component,
  render: self => <div onClick={self.handle(handleClick)}> {ReasonReact.string(gameName)} </div>,
};
