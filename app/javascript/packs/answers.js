$(document).on('turbolinks:load', function(){
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault();
    $(this).hide();
    const answerId = $(this).data('answerId');
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })
})

import consumer from '../channels/consumer'

const template = require('templates/answer.html.hbs')
const id = window.location.href.split("/").pop();

if (/questions\/\d/.test(window.location.href))
  consumer.subscriptions.create({channel: 'AnswersChannel', id: id}, {
    connected() {
      this.perform('follow')
    },
  
    received(data){
      if ($("#"+id+".question").length)
        if(gon.current_user.id == data.answer.user_id)
          $.extend(true, data, {author: true, vote: false})
        else
          if(gon.current_user.id)
            $.extend(true, data, {author: false,vote: true })
          else
            $.extend(true, data, {author: false,vote: false })
        $('.answers').append(template(data))
    }
  })

