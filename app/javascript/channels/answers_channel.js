import consumer from "./consumer"

$(document).on('turbolinks:load', function() {
    consumer.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
        received(data) {
            if (gon.current_user != null && gon.current_user.id == data['answer']['user_id']) { return; }

            $('#question-'+ gon.question_id +'-answers .answers').append(data['template']);

            if (gon.current_user != null) {
                $('.answers #answer-id-'+ data['answer']['id'] +' .rate-value').after(
                    "<div class=\"rate-actions\">" +
                    "<a data-type=\"json\" class=\"rate-cancel hidden\" data-remote=\"true\" rel=\"nofollow\" " +
                    "data-method=\"delete\" href=\"/answers/"+ data['answer']['id'] +"/cancel_rate\">Cancel</a>" +
                    "<a data-type=\"json\" class=\"rate-up\" data-remote=\"true\" rel=\"nofollow\" data-method=\"patch\" " +
                    "href=\"/answers/"+ data['answer']['id'] +"/rate_up\">Up</a>" +
                    "<a data-type=\"json\" class=\"rate-down\" data-remote=\"true\" rel=\"nofollow\" data-method=\"patch\" " +
                    "href=\"/answers/"+ data['answer']['id'] +"/rate_down\">Down</a>" +
                    "</div>"
                );

                $('.answers #answer-id-'+ data['answer']['id'] +' .rate-actions').on("click",".rate-up", function (e) {
                    e.preventDefault();
                    rateActions = $(this).parent();

                    $(this).addClass('hidden');
                    rateActions.find('.rate-down:first').addClass('hidden');

                    rateActions.find('.rate-cancel:first').removeClass('hidden');
                });

                $('.answers #answer-id-'+ data['answer']['id'] +' .rate-actions').on("click",".rate-down", function (e) {
                    e.preventDefault();
                    rateActions = $(this).parent();

                    $(this).addClass('hidden');
                    rateActions.find('.rate-up:first').addClass('hidden');

                    rateActions.find('.rate-cancel:first').removeClass('hidden');
                });

                $('.answers #answer-id-'+ data['answer']['id'] +' .rate-actions').on("click",".rate-cancel", function (e) {
                    e.preventDefault();
                    rateActions = $(this).parent();
                    $(this).addClass('hidden');

                    rateActions.find('.rate-up:first').removeClass('hidden');
                    rateActions.find('.rate-down:first').removeClass('hidden');
                });

                $('.answers #answer-id-'+ data['answer']['id'] +' .rate-actions').on('ajax:success', function (e) {
                    result = e.detail[0];

                    difference = result.difference;
                    answerId = result.record_id;

                    $('.answers #answer-id-'+ answerId +' .rate-value:first').html(difference)
                });
            }
        }
    });
});
