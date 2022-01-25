$(document).on('turbolinks:load', function(){
  $('.questions').on('click', '.edit-question-link', function(e) {
    e.preventDefault();
    $(this).hide();
    const questionId = $(this).data('questionId');
    $('form#edit-question-' + questionId).removeClass('hidden')
  })
})


import consumer from '../channels/consumer'

const template = require('templates/question.html.hbs')

if (/\/questions$/.test(window.location.href))
  consumer.subscriptions.create('QuestionsChannel',{
    connected() {
      this.perform('follow')
    },
  
    received(data){
      if (/\/questions$/.test(window.location.href))
        if(gon.current_user.id == data.question.user_id)
          $.extend(true, data, {author: true, vote: false})
        else
          if(gon.current_user.id)
            $.extend(true, data, {author: false,vote: true })
          else
            $.extend(true, data, {author: false,vote: false })
        $('.questions').append(template(data))
    }
  })
