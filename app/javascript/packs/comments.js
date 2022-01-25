import consumer from '../channels/consumer'

const template = require('templates/comment.html.hbs')
const id = window.location.href.split("/").pop();

if (/questions\/\d/.test(window.location.href))
  consumer.subscriptions.create({channel: 'CommentsChannel', id: id}, {
    connected() {
      this.perform('follow')
    },
  
    received(data){
      if ($("#"+id+".question").length)
        if(data.class == "Answer"){
          $('.answers #' + data.commentable.id +'.answer .comments .comments-body').append(template(data))
        }
        else{
          $("#"+ id +".question .comments .comments-body").append(template(data))
        }
                  
    }
  })

