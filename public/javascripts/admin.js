$(function(){

  $('.delete-result-button').on('click', function(event){
    event.preventDefault();
    var $button = $(event.target);
    var resultId = $button.data('id');

    $.ajax('/results/' + resultId, {
      method: 'delete',
      success: function(){
        var $resultBox = $button.closest('.result-box');
        var $queryBox = $button.closest('.query-box');
        $resultBox.animate({ width: 0 }, 400, 'swing', function(){
          console.log('ok i finished animating it');
          $resultBox.remove();

          // Count how many are left
          var updatedCount = $queryBox.find('.result-box').length
          // Update the counter
          var originalCount = $queryBox.find('.result-count');
          originalCount.text(updatedCount);
        });
      }
    });
  });

});
