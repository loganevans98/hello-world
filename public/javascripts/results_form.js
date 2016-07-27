$(function(){
  var bricklayer = new Bricklayer(document.querySelector('.bricklayer'));

  $('.search-form').on('submit',function(event){
    event.preventDefault();
    var $form = $(event.target);
    var $input = $form.find('[name="query_text"]');
    var query = $input.val();

    $.ajax('/search_giphy', {
      method: "post",
      data: { "query_text": query },
      success: function(data){
        var $image = $('<img class="result-image" src="' + data.image_url + '" />');

        bricklayer.prepend($image[0]);
        $('.label').text(data.query_text);
        $input.val(data.query_text);
      }
    });
  });
});
