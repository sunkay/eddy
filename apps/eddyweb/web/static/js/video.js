import Player from './player'

let video = {
  init(socket, element){
    if(!element){ return }
    let playerId = element.getAttribute("data-player-id")
    let videoId = element.getAttribute("data-id")
    socket.connect()
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket)
    })
  },

  onReady(videoId, socket){
    let msgContainer = document.getElementById("msg-container")
    let msgInput = document.getElementById("msg-input")
    let postButton = document.getElementById("msg-submit")
    let vidChannel = socket.channel("videos:" + videoId)

    postButton.addEventListener("click", e => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()}
      vidChannel.push("new_annotation", payload)
        .receive("error", e => console.log(e))
      msgInput.value = ""
    })

    vidChannel.on("new_annotation", (resp) => {
      this.renderAnnotation(msgContainer, resp)
    })

    vidChannel.join()
      .receive("ok", resp => console.log("joined the video channel", resp))
      .receive("error", reason => console.log("join failed", reason))
  },

  renderAnnotation(msgContainer, {user, body, at}) {
      let template = document.createElement("div")
      template.innerHTML = `
      <a href="#" class="annotations-text" data-seek="${at}">
        [${this.formatTime(at)}] <b>${user.username}</b>: ${body}
      </a>
      `
      msgContainer.appendChild(template)
      msgContainer.scrollTop = msgContainer.scrollHeight
  },

  formatTime(at) {
    let date = new Date(null)
    date.setSeconds(at / 1000)
    return date.toISOString().substr(14, 5)
  }

}
export default video;
