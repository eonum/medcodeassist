
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
      var selectedCodes = {};

      $(".selectable").selectable();


      $(".selectable").selectable({

              stop: function () {
                  $(".ui-selected", this).each(function () {
                      // add the code to allListMask and the appropriate tab-list in code Mask
                      var category = this.parentNode.id;
                      this.setAttribute("data-category", category);
                      $("#" + category + "Mask, #allListMask").append(this);
                      selectedCodes[this.id] = {code: this.id, description: this.description, category: this.category};
                  });
              }
      });

      $(".unselectable").selectable();

      $(".unselectable").selectable({

          stop: function () {
              $(".ui-selected", this).each(function () {
                  // add the code first to the appropriate list
                  var category = this.getAttribute("data-category");
                  $("#" + category).prepend(this);
                  // remove it from all tabs in codeMask
                  $(".codeMaskLists li").remove("#"+this.id);
                  delete selectedCodes[this.id];
              });
          }
      });

      $(".infoButton").click(function (){
          var codeId = this.parentNode.id;
          console.log("info id: "+codeId);
          $("#infoCode").empty().append(codeId);
          $("#infoSynonyms").empty().append("synonyms of code "+codeId);
          $("#infoDescription").empty().append("Description of code "+codeId);
          $("#infoDescription").append("<br>bla<br>bla<br>bla<br>bla");

      });

      $("#analyse").click(function () {
          // alert("HI");
          var code = "Code aasd";
          var text = $("#edit").html();
          var plainText = $("#edit").text();

          $.ajax({
              url : "/front_end/analyse",
              type : "post",
              data : { text_field: JSON.stringify(plainText) }
          });

          var words = ["ing", "is", "awesome"];
          words.forEach(function (item) {
              text = text.split(item).join("<a href='#' class='hight' data-toggle='tooltip' title='" + code + "'>" + item + "</a>");
          });
          $("#edit").html(text);
          // alert("Bye");
          for(var key in selectedCodes){
              console.log("code: "+selectedCodes[key].code);
              $("#codeList #"+selectedCodes[key].code).hide();
          }
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
  });
 
