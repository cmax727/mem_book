$(function() {

	var regions = [];
	$("select#signup_country").change(function(){
		var country = $("#signup_country option:selected").val();
		
		$.ajax({
			url: '/regions/fetch_regions/' + country,
			dataType: "json",
			async: false,
			success : function(data){
		       regions = data;
		       $('label.region').css('display', 'block')
		       $('select#signup_region').css('display', 'block')
		       $('#signup_region').empty()
		       $('label.city').css('display', 'none')
		       $('select#signup_city').css('display', 'none')
		       $('select#signup_city').empty()
		       $.each(data, function(id, region) {
		       		$('#signup_region').append($('<option>').text(region[1]).attr('value', region[0]));
		       });

		    }
		});		
	});
	
	$("select#signup_region").change(function(){
		var country = $("#signup_country option:selected").val();
		var region = $("#signup_region option:selected").val();
		$.ajax({
			url: '/cities/fetch_cities/' + country + '/' + region,
			dataType: "json",
			async: false,
			success : function(data){
		       cities = data;
		       $('label.city').css('display', 'block')
		       $('select#signup_city').css('display', 'block')
		       $('#signup_city').empty()
		       $.each(data, function(id, region) {
		       		$('#signup_city').append($('<option>').text(region[1]).attr('value', region[0]));
		       });
	
		    }
		});		
	});	


	$("#signup_agree").next().click(function() {
		
		if ($(this).is(':checked')) {
			console.log($('input.button.submit.big.signup').attr('disabled'));
			
			$('input.button.submit.big.signup').attr("disabled", false); 
			
		} else {
			console.log($('input.button.submit.big.signup')); 
			$('input.button.submit.big.signup').attr("disabled", true);
		}	
	});
	
	
});