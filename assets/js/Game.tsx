import { Channel, Socket } from "phoenix"
import * as React from "react"

interface Props {
  gameName: string
  socket: Socket
}

interface State {
  gameChannel: Channel
  hand: Card[]
  newGame: boolean
}

interface Card {
  name: string
  value: number
}

export class Game extends React.Component<Props, State> {
  constructor(props: Props, state: State) {
    super(props, state)

    props.socket.connect()
    this.state = {
      gameChannel: props.socket.channel("games:" + props.gameName),
      hand: [],
      newGame: true,
    }
  }
  public componentDidMount() {
    this.state.gameChannel
      .join()
      .receive("ok", (response) => {
        console.log("join", { response })
      })
      .receive("error", (reason) => {
        console.log("join failed", { reason })
      })

    this.state.gameChannel.on("player_hand", (response) => {
      if (response.hand) {
        this.setState({ newGame: false, hand: response.hand })
      }
    })
  }
  public render() {
    const { gameName } = this.props
    const { newGame } = this.state

    return (
      <>
        <h1>{gameName}</h1>
        {newGame && <button onClick={this.dealHand} className="button">Deal</button>}
        {this.renderHand()}
      </>
    )
  }
  private dealHand = () => {
    this.state.gameChannel
      .push("deal_hand", {})
      .receive("error", (error) => {
        console.log("deal_hand", { error })
      })
  }
  private renderHand = () => {
    return this.state.hand.map(this.renderCard)
  }
  private renderCard = (card: Card, index: number) => {
    return (
      <div key={index}>{card.value} {card.name}</div>
    )
  }
}
