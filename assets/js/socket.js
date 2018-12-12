import { Socket } from 'phoenix';

const socket = new Socket("/socket");
socket.connect();

if (document.getElementById('enable-polls-channel')) {
    const channel = socket.channel('polls:main');
    channel
        .join()
        .receive('ok', res => console.log('Joined channel:', res))
        .receive('error', res => console.log('Failed to join channel:', res));
    document.getElementById("polls-ping").addEventListener("click", () => {
        channel
            .push("hello")
            .receive('ok', res => console.log('PING response', res.message))
            .receive('error', res => console.log('Unable to ping', res))
        channel.on("world", payload => {
            console.log("Server has been pinged!", payload)
        })
    })
}
