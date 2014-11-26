$(function() {
$('button.facebook').click(function() {
  window.open('/auth/facebook');
  
});

$('button.twitter').click(function() {
  window.open('/auth/twitter');  
});

$('button.googleplus').click(function() {
  window.open('/auth/google_oauth2');
});		
}); 
