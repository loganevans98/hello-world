$(function(){

  $('.delete-result-button').on('click', function(event){
    var $button = $(event.target);
    var resultId = $button.data('id');

    $.ajax('/results/' + resultId, {
      method: 'delete',
      success: function(){
        var $resultBox = $button.closest('.result-box');
        var $queryBox = $button.closest('.query-box');
        $resultBox.animate({ width: 0 }, 400, 'swing', function(){
          $resultBox.remove();

          // Count how many are left
          var updatedCount = $queryBox.find('.result-box').length
          // Update the counter
          var originalCount = $queryBox.find('.result-count');
          originalCount.text(updatedCount);

          if (updatedCount === 0) {
            $queryBox.remove();
          }
        });
      }
    });
  });

  $('.delete-query-button').on('click', function(event) {
    var $button = $(event.target);
    var queryId = $button.data('id');

    $.ajax('/queries/' + queryId, {
      method: 'delete',
      success: function(){
        var $queryBox = $button.closest('.query-box');
        $queryBox.animate({height: 0}, 400, 'swing', function(){
          $queryBox.remove();
        });
      }
    });
  });

});
