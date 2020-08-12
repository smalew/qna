import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    gon.answer_ids.forEach(function (answer_id) {
        consumer.subscriptions.create({ channel: "CommentsChannel", record_type: 'answer', record_id: answer_id }, {
            received(data) {
                console.log(data);
                console.log(answer_id);
                if (gon.current_user != null && gon.current_user.id == data['user_id']) { return; }

                $('.answers #answer-id-'+ answer_id +' .comments').prepend("<p>"+ data['body'] + "</p>");
            }
        });
    });
});
