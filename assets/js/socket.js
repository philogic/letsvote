import { Socket } from 'phoenix';

const pushVote = (el, channel) => {
    channel
        .push('vote', {option_id: el.getAttribute('data-option-id')})
        .receive('ok', res => console.log('You voted!'))
        .receive('error', res => console.log('Failed', res))
        .on('new_vote', ({option_id, votes}) => {
            document.getElementById('vote-count-' + option_id).innerHTML = votes
        })
}

const onJoinChannel = (res, channel) => {
    document.querySelectorAll('.vote-button-manual').forEach(el => {
        el.addEventListener('click', event => {
            event.preventDefault();
            pushVote(el, channel);
            console.log('Do something!')
        })
    });
    console.log('Joined channel: ', res)
};

const socket = new Socket("/socket");
socket.connect();

const enableSocket = document.getElementById('enable-polls-channel');

if (enableSocket) {
    const pollId = enableSocket.getAttribute('data-poll-id');
    const channel = socket.channel('polls:' + pollId, {remote_ip: remoteIp});
    channel
        .join()
        .receive('ok', res => {onJoinChannel(res, channel)})
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
