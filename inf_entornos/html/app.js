$('document').ready(() => {
    window.addEventListener('message', (event) => ShowNotification(event.data));

    function ShowNotification(data) {
        let notification = CreateNotification(data);
        $('.notif-container').append(notification);
        setTimeout(() => $.when(notification.fadeOut()).done(() => notification.remove()), 10000);
    }

    function CreateNotification(data) {
        let notification = $(document.createElement('div'));
        notification.addClass('notification').addClass('police');
        notification.html('\
        <div class="content">\
        <div id="code">' + data.info["code"] + '</div>\
        <div id="code">' + data.info["id"] + '</div>\
        <div id="alert-name">' + data.info["title"] + '</div>\
        <div id="marker"><i class="fas fa-map-marker-alt" aria-hidden="true"></i></div>\
        <div id="alert-info">' + data.info['msg'] + '<br/><i class="fas fa-globe-europe"></i>' + data.info["loc"] +
            '<br/>[<span style="color: darkorchid">AVPAG</span>] Aceptar  |  [<span style="color: red">REPAG</span>] Rechazar</div>\
        </div>');
        notification.fadeIn();
        return notification
    }
})