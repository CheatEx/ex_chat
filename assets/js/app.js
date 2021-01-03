// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import deps with the dep name or local files with a relative path, for example:
//
//     import {Socket} from "phoenix"
//     import socket from "./socket"
//
import "phoenix_html"
import {Socket, Presence} from "phoenix"

let tokenMeta = document.querySelector("meta[name='socket_token']")
// Rely on SSR setting socket token only on chat page
let chatPage = tokenMeta !== null
if (chatPage) {
  let token = tokenMeta.getAttribute("content");
  let socket = new Socket("/socket", {params: {token: token}})

  socket.connect()

  let presences = {}

  let formatTimestamp = (timestamp) => {
    let date = new Date(timestamp)
    return date.toLocaleTimeString()
  }
  let listBy = (user, {metas: metas}) => {
    return {
      user: user,
      onlineAt: formatTimestamp(metas[0].online_at)
    }
  }

  let userList = document.getElementById("UserList")
  let render = (presences) => {
    userList.innerHTML = Presence.list(presences, listBy)
      .map(presence => `
        <li>
          <b>${presence.user}</b>
          <br><small>online since ${presence.onlineAt}</small>
        </li>
      `)
      .join("")
  }

  let room = socket.channel("room:lobby", {})
  room.on("presence_state", state => {
    presences = Presence.syncState(presences, state)
    render(presences)
  })
  room.join()

  let messageInput = document.getElementById("NewMessage")
  messageInput.addEventListener("keypress", (e) => {
    if (e.keyCode == 13 && messageInput.value != "") {
      room.push("message:new", messageInput.value)
      messageInput.value = ""
    }
  })

  let messageList = document.getElementById("MessageList")
  let renderMessage = (message) => {
    let messageElement = document.createElement("li")
    messageElement.innerHTML = `
      <b>${message.user}</b>
      <i>${formatTimestamp(message.timestamp)}</i>
      <p>${message.body}</p>
    `
    messageList.appendChild(messageElement)
    messageList.scrollTop = messageList.scrollHeight;
  }

  room.on("message:new", message => renderMessage(message))
}