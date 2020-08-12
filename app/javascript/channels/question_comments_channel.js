import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "CommentsChannel", record_type: 'question', record_id: gon.question_id }, {
        received(data) {
            if (gon.current_user != null && gon.current_user.id == data['user_id']) { return; }

            $('#question-'+ gon.question_id +' .comments').prepend("<p>"+ data['body'] + "</p>");
        }
    });
});
