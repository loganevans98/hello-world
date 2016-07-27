$(function(){
  $('.search-form').on('submit',function(event){
    event.preventDefault();
    var $form = $(event.target);
    var $input = $form.find('[name="query_text"]');
    var query = $input.val();

    $.ajax('/search_giphy', {
      method: "post",
      data: { "query_text": query },
      success: function(data){
        var $image = $('<img src="' + data.image_url + '" />');

        $('.search-results').prepend($image);
        $('.label').text(data.query_text);
        $input.val(data.query_text);
      }
    });
  });
});
