$(function(){
  new Bricklayer(document.querySelector('.past-queries'));


  var searchResults = new Bricklayer(document.querySelector('.search-results'));

  $('.search-form').on('submit',function(event){
    event.preventDefault();
    var $form = $(event.target);
    var $input = $form.find('[name="query_text"]');
    var query = $input.val();

    $('.past-queries').remove();

    $.ajax('/search_giphy', {
      method: "post",
      data: { "query_text": query },
      success: function(data){
        var $image = $('<img class="result-image" src="' + data.image_url + '" />');

        searchResults.prepend($image[0]);
        $input.val(data.query_text);
      }
    });
  });
});
