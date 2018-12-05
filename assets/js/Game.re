open Phx;

[@bs.deriving abstract]
type socketParams = {token: string};
[@bs.deriving abstract]
type socketOptions = {params: socketParams};

type game = {gameName: string};
type state = {
  gameChannel: Phx_channel.t,
  game,
};
type action =
  | Deal;

[@bs.deriving abstract]
type person = {
  name: string,
  age: int,
  job: string,
};

/*[@bs.val] external john: person = "john";*/

let component = ReasonReact.reducerComponent("Game");
let make = (~gameName, ~userToken, _children) => {
  ...component,
  initialState: () => {
    let params = socketParams(~token=userToken);
    let options = socketOptions(~params);
    let options2: socketOptions = {
      params: {
        token: userToken,
      },
    };
    Js.log(options);
    Js.log(options2);
    let socket: Phx.Socket.t = initSocket("/socket") |> connectSocket;
    let gameChannel: Phx_channel.t = socket |> initChannel("games:" ++ gameName);
    {
      gameChannel,
      game: {
        gameName: gameName,
      },
    };
  },
  reducer: (action: action, state: state) =>
    switch (action) {
    | Deal => ReasonReact.Update(state)
    },
  render: self =>
    <div>
      <h1> {ReasonReact.string(gameName)} </h1>
      <button className="button" onClick={_event => self.send(Deal)}> {ReasonReact.string("Deal")} </button>
    </div>,
};
