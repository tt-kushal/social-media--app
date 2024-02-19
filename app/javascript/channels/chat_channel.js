import consumer from "./consumer"

consumer.subscriptions.create({ channel: "ChatChannel", room_id: "1" }, {
  received(data) {
    console.log(data.message);
  }
});