
$(function() {


 /*********** place autocomplete - start **************/


    var locations = [];
    
    var first_char = '';
    
    $("input#profile_place").keyup(function() {	
    	first_char = $(this).val().split(" ").join("");
    	
		if(first_char.length == 3) {
			$.ajax({
					url: '/cities/autocomplete/' + first_char,
					dataType: "json",
					async: false,
					success : function(data){
					   console.log(data);
				       locations = data;
				    }
			});

		}
		

		$( "input#profile_place" ).autocomplete({
		   source: locations		 
		});

		
    });
 /*********** place autocomplete - end   **************/

 /*********** profile country, region, city options - start   **************/
	var regions = [];
	$("select#profile_country").change(function(){
		var country = $("#profile_country option:selected").val();
		$.ajax({
			url: '/regions/fetch_regions/' + country,
			dataType: "json",
			async: false,
			success : function(data){
			   console.log(data);
		       regions = data;
		       $('#profile_region').empty()
		       $('#profile_city').empty()
		       $.each(data, function(id, region) {
		       		$('#profile_region').append($('<option>').text(region[1]).attr('value', region[0]));
		       });
		    }
		});		
	});
	
	$("select#profile_region").change(function(){
		var country = $("#profile_country option:selected").val();
		var region = $("#profile_region option:selected").val();
		$.ajax({
			url: '/cities/fetch_cities/' + country + '/' + region,
			dataType: "json",
			async: false,
			success : function(data){
			   console.log(data);
		       regions = data;
		       $('#profile_city').empty()
		       $.each(data, function(id, city) {
		       		$('#profile_city').append($('<option>').text(city[1]).attr('value', city[0]));
		       });
		    }
		});		
	});	
 /*********** profile country, region, city options - end   **************/

 /*********** interest tag - start   **************/
	
/*

	
	$("input#add_interest").keypress(function(e){		
		if ( e.which == 13 ){
			var interest = $(this).val();
			$(this).val('');
			$.ajax({
				url: '/interests/create/' + interest,
				dataType: "json",
				async: false,
				success : function(data){
					if(data !== null){
						
						$('#interest_target').append('<span class="an_interest">' + data.name + '</span>');
						// $('#interest_target').css('visiblity', '');
					}
				}				
			});		
			return false;
		}

		
    });
   
   var interests = []; 
   $("input#add_interest").keyup(function() {	
    	first_char = $(this).val().split(" ").join("");
    	
		if(first_char.length == 1) {
			$.ajax({
					url: '/interests/autocomplete/' + first_char,
					dataType: "json",
					async: false,
					success : function(data){
				       interests = data;
				    }
			});

		}
		

		$( "input#add_interest" ).autocomplete({
		   source: interests		 
		});

		
    });
    
  */

        
 /*********** interest tag - end   **************/

 /*********** view profile page interest tag - start   **************/
	$("#myTags").tagit({
	    caseSensitive: false,
/*
	    beforeTagAdded: function(event, ui) {
	    	var interest = ui.tagLabel
	    	if(ui.duringInitialization !== true){
	    		$.ajax({
					url: '/interests/create/' + interest
				});	
	    	}	    	
    	}
*/

    	

	});
/*********** view profile page interest tag - end   **************/

/*********** view profile page aboutMe edit - start   **************/
	  $("#aboutMe_edit").on("click", function(event){
	    event.preventDefault();
	    $("#modal_window.aboutMe_edit").fadeIn("fast");
	    $("#close.aboutMe_edit").click(function(){
	      $(this).parent().fadeOut("fast");
	    })
	  })
/*********** view profile page aboutMe edit - end   **************/

/*********** view profile page tag edit - start   **************/
	  $("#interest_edit").on("click", function(event){
	  	$('ul.tags').css('display', 'none');
	  	$('ul#myTags').css('display', 'block');
	  	$('a#interest_cancel').css('display', 'block');
	  	$('#interest_edit').css('display', 'none');
	  	$('a#interest_save').css('display', 'block');
	  })
	  
	  $("#interest_cancel").on("click", function(event){
	  	$('ul.tags').css('display', 'block');
	  	$('ul#myTags').css('display', 'none');
	  	$('a#interest_cancel').css('display', 'none');
	  	$('#interest_edit').css('display', 'block');
	  	$('a#interest_save').css('display', 'none');
	  })
	  
	  $("#interest_save").on("click", function(event){
	  	var interestArray = [];
	  	$('ul#myTags li span.tagit-label').each(function(i)
		{
		   interestArray[i] = $(this).text(); // This is your rel value
		});
		var url = '/interests/create/' + interestArray;
		console.log(interestArray);
		$(this).attr("href", url);
		/*
		
				$.ajax({
					url: '/interests/create/' + interestArray,
					dataType: "html"
				});*/
		
	  })
/*********** view profile page tag edit - end   **************/

});