var advanced;

function initialize () {
  $(".instructions").hide();
  $("#advanced").hide();
  $("#olympiad_bowl_pf").show();
  advanced=0;
}

function toggleProfile () {
  $(".instructions").hide();
  $('#'+$("#profile").val()).show();
}

function toggleAdvanced () {
  if (advanced) { 
    $("#advancedbtn").attr('value','Show advanced options')
    $("#advanced").hide();
  }
  else {
    $("#advancedbtn").attr('value','Hide advanced options')
    $("#advanced").show();
  }
  advanced = 1 - advanced;
}
