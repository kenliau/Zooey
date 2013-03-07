var stages = {
  numOfStages : 4,
  pull : 2,
  tcoder: 1,
  chunker: 0,
  merger: 0
}

var jobStatus = {
  stages_id : ['pull', 'tcoder', 'chunker', 'merger'],  
  
  getStatus : function() {
    // AJAX CALL
/*    $.getJSON('/path_to_your_controller', function(data) {
      //set the stages
      console.log(data);
    });
*/
    this.redraw();
  },

  redraw : function() {
    $.each(this.stages_id, function(i, stg) {
      var foo = $('#' + stg);
      if(stages[stg] == 1) {
        foo.css({ "backgroundColor": "#a9a9a9" });
        jobStatus.blink(foo);
      } else if (stages[stg] == 2) {
        foo.css({ "backgroundColor": "#2ba6cb" });
      } else {
        foo.css({ "backgroundColor": "#a9a9a9" });
        return;
      }
      return;
    })
  },

  blink : function(elem) {
    var stgId = elem.attr('id');
    if(stages[stgId] == 2 || stages[stgId] == 0 ){
      return;
    }
    var color = elem.css("background-color");
    if(color == 'rgb(169, 169, 169)') {
      elem.animate({
        backgroundColor: "#2ba6cb"
      }, 500, function() {
          jobStatus.blink(elem);
          console.log(elem);
          console.log("to blue callback");
      });
    } else {
      elem.animate({
        backgroundColor: "#a9a9a9"
      }, 500, function() {
          jobStatus.blink(elem);
          console.log(elem);
          console.log("to black callback");
      });
    }

  }

}

$(function() { 
  jobStatus.getStatus();
  setInterval(function() {
    jobStatus.getStatus();
  }, 10000);
});
