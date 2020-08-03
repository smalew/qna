$(document).on('turbolinks:load', function () {
    $('.answers').on('click', '.edit-answer-link', function (e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    });

    $('.answers .rate-actions').on("click",".rate-up", function (e) {
        e.preventDefault();
        rateActions = $(this).parent();

        $(this).addClass('hidden');
        rateActions.find('.rate-down:first').addClass('hidden');

        rateActions.find('.rate-cancel:first').removeClass('hidden');
    });

    $('.answers .rate-actions').on("click",".rate-down", function (e) {
        e.preventDefault();
        rateActions = $(this).parent();

        $(this).addClass('hidden');
        rateActions.find('.rate-up:first').addClass('hidden');

        rateActions.find('.rate-cancel:first').removeClass('hidden');
    });

    $('.answers .rate-actions').on("click",".rate-cancel", function (e) {
        e.preventDefault();
        rateActions = $(this).parent();
        $(this).addClass('hidden');

        rateActions.find('.rate-up:first').removeClass('hidden');
        rateActions.find('.rate-down:first').removeClass('hidden');
    });

    $('.answers .rate-actions').on('ajax:success', function (e) {
        result = e.detail[0];

        difference = result.difference;
        answerId = result.record_id;

        $('.answers #answer-id-'+ answerId +' .rate-value:first').html(difference)
    });
});
