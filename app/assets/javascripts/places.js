
$(function() {
	
 /*********** select country - start **************/
	$("#country").change(function(){
		var country = $("#country option:selected").text();
		
		window.location.assign("/countries/" + country);
	});
	
   $('#vmap').vectorMap({
      map: 'world_en',
      backgroundColor: '#fff',
      borderColor: '#fff',
      borderOpacity: 0.5,
      borderWidth: 2,
      color: '#a5bfdd',
      enableZoom: false,
      normalizeFunction: 'polynomial',
      hoverOpacity: 0.7,
      hoverColor: '#c9dfaf',
      selectedColor: '#666666',
      showTooltip: true,
      onRegionClick: function(element, code, region) {
      	$.ajax({
			url: '/places/change_regions/',
			dataType: 'script',
			data: { region: region, code: code }
		});
      	
      }
   });


 /*********** select country - end   **************/



});