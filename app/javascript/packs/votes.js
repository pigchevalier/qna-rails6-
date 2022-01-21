$(document).on('turbolinks:load', function(){
  $(document).on('ajax:success', '.new-vote', function(e) {
    let arr = e.detail[0];
    let rating = arr[0];
    let voteId = arr[1];
    let id = $(this).attr('id')
    $('#'+id+'.del-vote-link').html('<a id="'+id+'" class="del-vote" rel="nofollow" data-method="delete" data-remote="true" href=/votes/' + voteId + '>Unvote'+'</a>');
    $('#'+id+'.new-vote').addClass('hidden');
    $('#'+id+'.rating').html('<p>' + 'Rating: ' + rating + '</p>');
  })
    .on('ajax:success', '.del-vote', function(e) {
      let rating = e.detail[0];
      let id = $(this).attr('id')
      $('#'+id+'.del-vote').html('');
      $('#'+id+'.new-vote').removeClass('hidden');
      $('#'+id+'.rating').html('<p>' + 'Rating: ' + rating + '</p>');
    })
    .on('ajax:error', '.del-vote', function(e) {
      let errors = e.detail[0];
      $('#'+id+'.vote-errors').html('');

      $.each(errors, function(index, value){
        $('#'+id+'.vote-errors').append('<p>' + value + '</p>');
      })      
    })
    .on('ajax:error', '.new-vote', function(e) {
      let errors = e.detail[0];
      $('#'+id+'.vote-errors').html('');

      $.each(errors, function(index, value){
        $('#'+id+'.vote-errors').append('<p>' + value + '</p>');
      })      
    })
});  
  
