/*
  jQuery UI CoverFlow 2.1.2 App for jQueryUI 1.8.9 / core 1.6.2
  Copyright Addy Osmani 2011.

  With contributions from Paul Bakhaus, Nicolas Bonnicci
*/

$(function() {
  //cache core component references
  // var html = $('#demo div.wrapper').html();
  var imageCaption = $('#imageCaptions');
  // $('#demo div.wrapper').parent().append(html).end().remove();
  $sliderCtrl = $('#slider');
  $coverflowCtrl = $('#coverflow');
  $coverflowImages = $coverflowCtrl.children('li');
  // $sliderVertical  = $("#slider-vertical");

  //app defaults
  var defaultItem = 0;
  var listContent = "";

  //Set the default image index.
  setDefault(13);

  //Set the default item to display on load.
  //Correct indexing
  function setDefault($n){
    defaultItem = $n-1;
  }

  // set the image caption
  function setCaption($pp, $p, $c, $n, $nn){
    $("#caption .prevprev").html($pp);
    $("#caption .prev").html($p);
    $("#caption .current").html($c);
    $("#caption .next").html($n);
    $("#caption .nextnext").html($nn);
  }

  //Initialize CoverFlow
  $coverflowCtrl.coverflow({
    item: defaultItem,
    duration: 1200,
    select: function(event, sky) {
      skipTo(sky.value);
    }
  });

  //Initialize Horizontal Slider
  $sliderCtrl.slider({
    min: 0,
    max: $('#coverflow > *').length-1,
    value: defaultItem,
    slide: function(event, ui) {
      $coverflowCtrl.coverflow('select', ui.value, true);
      // $('.coverflowItem').removeClass('ui-selected');
      // $('.coverflowItem:eq(' + (ui.value) +')').addClass('ui-selected');
      var prevprev = $('.coverflowItem:eq(' + (ui.value-2) +')').html()
      var prev = $('.coverflowItem:eq(' + (ui.value-1) +')').html()
      var current = $('.coverflowItem:eq(' + (ui.value) +')').html()
      var next = $('.coverflowItem:eq(' + (ui.value+1) +')').html()
      var nextnext = $('.coverflowItem:eq(' + (ui.value+2) +')').html()
      setCaption(prevprev, prev, current, next, nextnext)
    }
  });

  //Skip to an item in the CoverFlow
  function skipTo($itemNumber) {
    $sliderCtrl.slider("option", "value", $itemNumber);
    $coverflowCtrl.coverflow('select', $itemNumber, true);
    // $('.coverflowItem').removeClass('ui-selected');
    // $('.coverflowItem:eq(' + ($itemNumber) +')').addClass('ui-selected');
    // setCaption($('.coverflowItem:eq(' + ($itemNumber) +')').html());
    var prevprev = $('.coverflowItem:eq(' + ($itemNumber-2) +')').html()
    var prev = $('.coverflowItem:eq(' + ($itemNumber-1) +')').html()
    var current = $('.coverflowItem:eq(' + ($itemNumber) +')').html()
    var next = $('.coverflowItem:eq(' + ($itemNumber+1) +')').html()
    var nextnext = $('.coverflowItem:eq(' + ($itemNumber+2) +')').html()
    setCaption(prevprev, prev, current, next, nextnext)
  }

  $(".pagination a").click(function(e) {
    $current = $sliderCtrl.slider('value');
    var data = $(this).parent('li').attr('data');
    var length = $('#coverflow > *').length
    if (data != length) {
      $(this).parent('li').click();
      e.preventDefault();
    }
    else {
      $("#lightbox").fadeToggle();
    }
  });

  //Generate the text-list of items below the coverflow images.
  $coverflowImages.each(function(index, value) {
     $name = $(this).children('img').attr('data-name');
     $year = $(this).children('img').attr('data-year');
     try {
        listContent += "<li class='coverflowItem' data-itemlink='"
           + (index) +"'><span class='year'>" + $year + "</span><span class='name'>" + $name +"</span></li>";
     } catch(e) {
     }
  });

  //Skip all controls to the current default item
  $(imageCaption).html(listContent);
  // skipTo(defaultItem);

  //Assign click event for coverflow images
  // $('body').delegate('.coverflowItem','click', function(){
  //    skipTo($(this).data('itemlink'));
  // });

  //Handle keyboard events
  // $(document).keydown(function(e){
  //   $current = $sliderCtrl.slider('value');
  //    switch(e.keyCode){
  //      case 37:
  //      if($current > 0){
  //        $current--;
  //        skipTo($current);
  //      }
  //      break;
  //
  //      case 39:
  //      if($current < $('#coverflow > *').length-1){
  //        $current++;
  //        skipTo($current);
  //       }
  //      break;
  //    }
  // });

  //change the main div to overflow-hidden as we can use the slider now
  // $("#scroll-pane").css('overflow','hidden');

  // calculate the height that the scrollbar handle should be
  // var difference = $("#sortable").height()-$("#scroll-pane").height();//eg it's 200px longer
  // var difference = $("#scroll-pane").height();
  // var proportion = difference / $("#sortable").height();//eg 200px/500px
  // var handleHeight = Math.round((1-proportion)*$("#scroll-pane").height());//set the proportional height

  // //set up the slider
  // $sliderVertical.slider({
  //   orientation: "vertical",
  //   range: "max",
  //   min: 0,
  //   max: 100,
  //   value: 0 ,
  //   slide: function(event, ui) {
  //     var topValue = -((100-ui.value)*difference/100);
  //     $("#sortable").css({top:topValue});//move the top up (negative value) by the percentage the slider has been moved times the difference in height
  //   }
  // });
  //
  // var origSliderHeight = $sliderVertical.height();//read the original slider height
  // var sliderHeight = origSliderHeight - handleHeight ;//the height through which the handle can move needs to be the original height minus the handle height
  // var sliderMargin =  (origSliderHeight - sliderHeight)*0.5;//so the slider needs to have both top and bottom margins equal to half the difference
  //
  // /*Force the scrollers to bring the current item into view.*/
  // /*This can all be commented out if not needed*/
  // function setScrollPositions(item){
  //   var q =  item * 5;
  //   var qx = -35;
  //   $sliderVertical.slider('value', q);
  //   $('#sortable').css('top', -q + qx);
  // }
  //
  // setScrollPositions(defaultItem);

  //mousewheel support
  $("#gallery").mousewheel(function(event, delta){
    var speed = 1;
    var sliderVal = $sliderCtrl.slider("value");//read current value of the slider
    var coverflowItem = 0;
    var cflowlength = $('#coverflow > *').length-1;

    // check the deltas to find out if the user has scrolled up or down
    if (delta > 0 && sliderVal > 0) {
      sliderVal -=1;
    } else if (delta < 0 && sliderVal < cflowlength) {
      sliderVal +=1;
    }

    // var leftValue = -((100-sliderVal)*difference/100);//calculate the content top from the slider position
    //
    // if (leftValue>0) leftValue = 0;//stop the content scrolling down too much
    // if (Math.abs(leftValue)>difference) leftValue = (-1)*difference;//stop the content scrolling up beyond point desired

    coverflowItem = Math.floor(sliderVal);
    skipTo(coverflowItem);

    event.preventDefault();//stop any default behaviour
  });

  // forward and back controls
  $(".cover.prev").click(function() {
    $current = $sliderCtrl.slider('value');
    if($current > 0){
      $current--;
      skipTo($current);
    }
  });

  $(".cover.next").click(function() {
    $current = $sliderCtrl.slider('value');
    if ($current < $('#coverflow > *').length-1) {
      $current++;
      skipTo($current);
    }
  });
});