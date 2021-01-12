$(document).on('turbolinks:load', function () {
    $('#question-'+ gon.question_id).on('click', '.edit-question-link', function (e) {
        e.preventDefault();
        $(this).hide();
        $('form#edit-question').removeClass('hidden');
    });

    $('#question-'+ gon.question_id +' .rate-actions').on("click",".rate-up", function (e) {
        e.preventDefault();
        $(this).addClass('hidden');
        $('#question-'+ gon.question_id +' .rate-actions .rate-down:first').addClass('hidden');

        $('#question-'+ gon.question_id +' .rate-actions .rate-cancel:first').removeClass('hidden');
    });

    $('#question-'+ gon.question_id +' .rate-actions').on("click",".rate-down", function (e) {
        e.preventDefault();
        $(this).addClass('hidden');
        $('#question-'+ gon.question_id +' .rate-actions .rate-up:first').addClass('hidden');

        $('#question-'+ gon.question_id +' .rate-actions .rate-cancel:first').removeClass('hidden');
    });

    $('#question-'+ gon.question_id +' .rate-actions').on("click",".rate-cancel", function (e) {
        e.preventDefault();
        $(this).addClass('hidden');

        $('#question-'+ gon.question_id +' .rate-actions .rate-up:first').removeClass('hidden');
        $('#question-'+ gon.question_id +' .rate-actions .rate-down:first').removeClass('hidden');
    });

    $('#question-'+ gon.question_id +' .rate-actions').on('ajax:success', function (e) {
        difference = e.detail[0].difference;

        $('#question-'+ gon.question_id +' .rate-value:first').html(difference)
    });

    $('#question-'+ gon.question_id +' #subscription').on("click",".subscribe", function (e) {
        e.preventDefault();
        $(this).addClass('hidden');
        $('#question-'+ gon.question_id +' #subscription .subscribe:first').addClass('hidden');
        $('#question-'+ gon.question_id +' #subscription .unsubscribe:first').removeClass('hidden');
    });

    $('#question-'+ gon.question_id +' #subscription').on("click",".unsubscribe", function (e) {
        e.preventDefault();
        $(this).addClass('hidden');
        $('#question-'+ gon.question_id +' #subscription .unsubscribe:first').addClass('hidden');
        $('#question-'+ gon.question_id +' #subscription .subscribe:first').removeClass('hidden');
    });
});
