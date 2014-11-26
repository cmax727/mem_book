$(function() {
 /*********** edit caption modal - start **************/
	var caption = $( "#caption" ),
	  allFields = $( [] ).add( caption ),
	  tips = $( ".validateTips" );
	 
	 
	    $( "#caption_dialog" ).dialog({
	  autoOpen: false,
	  height: 300,
	  width: 350,
	  modal: true,
	  buttons: {
	
	    "Change Caption": function() { 
	    	
	
	    	var frm = $('#caption_dialog form')	   
	        frm.submit();    
/*
           $.ajax({
               type: frm.attr('method'),
               url: frm.attr('action'),
               data: frm.serialize(),
           });  */
 
	
		
	         $( this ).dialog( "close" );
	     
	    },
	
	    Cancel: function() {
	      $( this ).dialog( "close" );
	    }
	  },
	  close: function() {
	    allFields.val( "" ).removeClass( "ui-state-error" );
	      }
	    });
	 
	  $( "#caption_edit" )
	  .click(function() {
	    // alert("xdaf");
	    $( "#caption_dialog" ).dialog( "open" );
	  });
	  
 /*********** edit caption modal - end **************/


 /*********** upload picture - start **************/

    $( "#picture_avatar1" ).change(function() {
        
        var img_url = $( this ).val();
        
        // $('#imgTarget').attr('src', img_url);
    });

 /*********** upload picture - end   **************/



});