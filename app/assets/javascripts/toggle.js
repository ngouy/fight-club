$(function() {
  $('div.toggle-on-click').click(function(event){
    event.preventDefault();
    $(this).find('.toggled-click-content').toggleClass('show');
  });
});

$(function() {
  $(".toggle-on-hover")
    .mouseover(function() {
      $(this).find('.toggled-hover-content').toggleClass('show');
    })
    .mouseout(function() {
      $(this).find('.toggled-hover-content').toggleClass('show');
    });
 });