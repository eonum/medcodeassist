
//   $(function (){$('textarea').highlightTextarea({
//     words: ['Antonis', 'is']
//   });
// })
// $(function () {
//   $('.highlightTextarea .highlightTextarea-highlighter').hover(function(){
//   	confirm("HI!");
//   });
// });
  $(function() {

    $(".selectable").selectable();


    $(".selectable").selectable({
        stop: function() {
            $(".ui-selected", this).each(function(){
                this.parentId=this.parentNode.id;
                $("#"+this.parentId+"Mask, #allListMask").append(this);
            });

        }})});

     // $("#infoButton").click(function (){
     //
     // }

      /*
        {
            stop: function() {
                var result = $( "#select-result" ).empty();
                $( ".ui-selected", this ).each(function() {
                    var index = $( ".selectable li" ).index( this );
                    result.append( " #" + ( index + 1 ) );
                });
            }
        }
        */
    });


    $(".unselectable").selectable({
        stop: function () {
            $(".ui-selected", this).each(function () {
                var id = this.parentId;
                $("#"+id).prepend(this);
            });
        }
    });
      
    $("#analyse").click(function(){
      // alert("HI");
      var code="Code aasd";
      var text= $( "#edit" ).html();
      var words=["ing", "is","awesome"]
      words.forEach(function(item) {
          text=text.split(item).join("<a href='#' class='hight' data-toggle='tooltip' title='"+code +"'>"+item+"</a>");
      });
      $("#edit").html(text);
      // alert("Bye");
    });


// $("#edit").keypress(function( event ) {
//     if(event.which==13){
//         $("#edit").append("\n");
//        var x =$("#edit").caret('position');
//      $("#edit").caret('position', x);
//     }
//     else if(event.which!=8){
//       var x =$("#edit").caret('pos');
//       var code="Code";
//       var text= $( "#edit" ).text();
//       var words=["ing", "is","awesome"]
//       words.forEach(function(item) {
//        text=text.split(item).join("<a href='#' class='hight data-toggle='tooltip' title="+code+" "+item+">"+item+"</a>");
//       });
//       // text=text.split("Antonis").join("<span class=hight>Antonis</span>");

//       $("#edit").html(text);
//        $("#edit").caret('pos', x);
//        x=0;
//    }

//   });


      // $("#edit").html( $("#edit").html().replace( "Antonis", "<span class='hight'>Antonis</span> " ) )

   //    $( "#edit" )
   //      .focusin(function() {

   // var text= $( "#edit" ).text();

   // text=text.replaceAll("Antonis","<span class='hight'>Antonis</span> ");

   // $("#edit").html(text);
   //    // $("#edit").html( $("#edit").html().replace( "Antonis", "<span class='hight'>Antonis</span> " ) );
   //  });


  // });
 
