
$.fn.checkbox = function() {

  return this.each(function() {

    var s = $(this);

    s.hide().after('<span class="checkbox" data-name="'+s.attr("name")+'"><em class="checkmark"></em></span>');

    var checkbox = s.next();

    checkbox.bind("click", function(){

      if(checkbox.hasClass("checked")) {
        checkbox.checkboxUnCheck();
      } else {
        checkbox.checkboxCheck();
      }
    });

    if(s.is(':checked')) {
      checkbox.checkboxCheck();
    }

    $('label[for="'+s.attr("id")+'"]').bind("click", function(){
      if(checkbox.hasClass("checked")) {
        checkbox.checkboxUnCheck();
      } else {
        checkbox.checkboxCheck();
      }
    });
  });
};

$.fn.checkboxCheck = function() {

  return this.each(function() {

    var s = $(this);

    s.addClass("checked");
    s.prev("input").attr("checked", "checked");

    if( s.prev("input").attr('data-rel') ) {
      $("#" + s.prev("input").attr('data-rel')).addClass("required");
    }
  });
};

$.fn.checkboxUnCheck = function() {
  return this.each(function() {
    var s = $(this);
    s.removeClass("checked");
    s.prev("input").removeAttr("checked");

    if( s.prev("input").attr('data-rel') ) {
      $("#" + s.prev("input").attr('data-rel')).removeClass("required");
    }
  });
};

$(function() {
  $("button.mod-options").click(function () {
      $(this).parent().find(".options-list").toggle();
  })

  /* Form elements extension */

  $(document).on("focus", "form input, form textarea", function(){
    $(this).addClass("focus");
    if($(this).attr("data-default-value") && $(this).val() == $(this).attr("data-default-value")) {
      $(this).val("");
    }
  });

  $(document).on("blur", "form input, form textarea", function(){
    $(this).removeClass("focus");
    if($(this).attr("data-default-value") && $(this).val() == "") {
      $(this).val($(this).attr("data-default-value"));
    }
  });

  $(document).on("click", "form a.submit, form [href='#submit']", function(){
    var f = $(this).closest("form");
    f.submit();
    return false;
  });

  $(document).on("click", "form input.reset", function() {
    var f = $(this).closest("form");
    f.clearForm();
    return false;
  });

  $(document).on("click", "span.an_interest em.remove_interest", function() {
    $(this).parent().remove();
  });

  //interests
  //
  // adds interests to the interests div
  //

  $(document).on("click", "input#add_interests", function() {
    var the_input = $(this);

    $(the_input).val() === "Type an interest and press enter..."?$(the_input).val(""):null;

    $(document).keydown(function(){

      var code = (event.keyCode ? event.keyCode : event.which);

      if(the_input.val() !== "" && code === 13){

        var html_string = "<span class=\"an_interest\">"+  the_input.val()  +"<em class=\"remove_interest\">x</em></span>"

        $('#interest_target').append(html_string);

        the_input.val("");
      }
    })
  });


  /* Form with placeholders */
	$("form .placeholder + input, form .placeholder + textarea").each(function(){
	  if( $(this).val() !== "" )
	  {
	    $(this).prev("label.placeholder").hide();
	  }
	})

  $(document).on("focus", "form .placeholder + input, form .placeholder + textarea", function() {
    $(this).prev("label.placeholder").hide();
  });

  $(document).on("blur", "form .placeholder + input, form .placeholder + textarea", function() {
    if($(this).val() == '') $(this).prev("label.placeholder").show();
  });

  /* Update status form */

  if($("form.update-status").length) {

    $("form.update-status textarea").each(function(){
      $(this).val( $(this).attr("data-value") );
    });

    $("form.update-status textarea").focus(function(){
      var form = $(this).closest("form");
      $(this).val("");
      form.addClass("active");
    });

    // $("form.update-status textarea").blur(function(e){
      // e.stopImmediatePropagation();
      // return false;
    // });

    $(window).click(function(e){

      var target = $(e.target);

      if(!target.is("form.update-status") && target.closest("form.update-status").length == 0) {
        var form = $("form.update-status");
        var textarea = $("form.update-status textarea");
        var value = textarea.val();
        if(value == "") {
          form.removeClass("active");
          textarea.val( textarea.attr("data-value") );
        }
      }
    });

  }

  $("#edit_place_expand").on("click", function(){
    $(this).toggleClass("on");
    var form = $("form[name=place_change]");
    form.toggle();
  })

  /* Meters */

  if($(".tags, .tags-meter").length) {
    $(".tags .meter, .tags-meter .meter").each(function(){
      var v = $(this).attr("data-value");
      $(this).animate({width: v + "%"}, 1000)
    });
  }
/*

  $("#new_message").on("click", function(event){
    event.preventDefault();
    $("#modal_window").fadeIn("fast");
    $("#close").click(function(){
      $(this).parent().fadeOut("fast");
    })
  })
*/

  $("#new_discussion").on("click", function(event){
    event.preventDefault();
    $("#modal_window").fadeIn("fast");
    $("#close").click(function(){
      $(this).parent().fadeOut("fast");
    })
  })
  
  $("#reply_message").on("click", function(event){
    event.preventDefault();
    $("#modal_window").fadeIn("fast");
    $("#close").click(function(){
      $(this).parent().fadeOut("fast");
    })
  })

    $("#discussion_edit").click(function(){
      event.preventDefault();
      $("#modal_window.edit").fadeIn("fast");
      $("#modal_window.edit #close").click(function () {
          $(this).parent().fadeOut("fast");
      })
    })

  $("#sendMessage").on("click", function(event){
    event.preventDefault();
    $("#modal_window").fadeIn("fast");
    $("#close").click(function(){
      $(this).parent().fadeOut("fast");
    })    
  })

  $("li.flag").on("click", function (event) {
  	  var id_str = $(this).attr('id')
  	  var comment_id = (id_str.split('_'))[1]
  	  
	  // comment id to hidden tag in modal window	
  	  $('input#comment_id').attr('value', comment_id);
      event.preventDefault();
      $("#modal_window").fadeIn("fast");
      $("#close").click(function () {
          $(this).parent().fadeOut("fast");
      })
  })

  /* Checkboxes */


  if($('input[type="checkbox"]').length) {
    $('input[type="checkbox"]').checkbox();
  }




  /* Action togglers */

  if($("a.toggle-action").length) {

    $("a.toggle-action").click(function(e){
      e.preventDefault();
      var s = $(this);
      var action = s.text();
      var opposite_action = s.attr("data-opposite-action");
      $.ajax({
        url: s.attr("href") + "?action=" + action,
        context: document.body
      }).done(function() {
        s.text(opposite_action).attr("data-opposite-action", action);
        if(s.hasClass('active')) {
          s.unbind("mouseleave").removeClass('active').removeClass("done").addClass("deactivate");
          s.bind("mouseleave", function(){
            s.removeClass("deactivate");
          });
        } else {
          s.unbind("mouseleave").addClass('active');
          s.bind("mouseleave", function(){
            s.addClass("done");
          });
        }
      });
    });
  }


  /* Popups */

  if($(".popup-holder").length) {

    $(".popup-holder > a").click(function(e){
      e.preventDefault();
      var s = $(this);
      s.parent().toggleClass("active");
    });

    $(document).click(function(e){
      var target = $(e.target);
      var skip = target.parentsUntil("body", ".popup-holder");
      skip.add(target.closest(".popup-holder"));
      if(target.is(".popup-holder")) {
        skip.add(target);
      }
      $(".popup-holder").not(skip).removeClass("active");
    });
  }


  /* Popups */

  if($(".switch").length) {

    $(".switch > a").on("click", function(e){

      e.preventDefault();

      var s = $(this);
      var sw = $(this).parent();
      var fo = $("> ul > li:first-child", sw);

      $.ajax({
        url: $("> a", fo).attr("href"),
        context: document.body
      }).done(function() {

        var foa = $("> a", fo).clone();
        fo.remove();
        var sc = s.clone();
        $("> ul", sw).append("<li></li>");
        $("> ul > li:last-child", sw).html(sc);
        s.replaceWith(foa);

      });
    });
  }

  $(".flashmessages > div").each(function(){
    $(this).find(".message").text().length === 0?$(this).remove():null;
  })

  $(".close").each(function(){

    $(this).bind("click", function(){

      $(this).parent().fadeOut();

    })

  })
  
  // event search autocomplete part
    var events = [];
    
    var first_char = '';
    
    $("input#event-search-query").keyup(function() {
    	first_char = $(this).val().split(" ").join("");
		if(first_char.length == 1) {
			$.ajax({
					url: '/events/autocomplete/' + first_char,
					dataType: "json",
					async: false,
					success : function(data){
				       events = data;
				    }
			});

		}
		$( this ).autocomplete({
		   source: events		 
		});
    });
    
  // group search autocomplete part
    var groups = [];
    
    var first_char = '';
    
    $("input#group-searh-query").keyup(function() {
    	first_char = $(this).val().split(" ").join("");
		if(first_char.length == 1) {
			$.ajax({
					url: '/groups/autocomplete/' + first_char,
					dataType: "json",
					async: false,
					success : function(data){
					   console.log(data);
				       groups = data;
				    }
			});

		}
		$( this ).autocomplete({
		   source: groups		 
		});
    });    

});





/*

 $.widget( "custom.catcomplete", $.ui.autocomplete, {
    _renderMenu: function( ul, items ) {
      var that = this,
        currentCategory = "";
      $.each( items, function( index, item ) {
        if ( item.category != currentCategory ) {
          ul.append( "<li class='ui-autocomplete-category'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        that._renderItemData( ul, item );
      });
    }
  });


  $(function() {
    var search_data = [
      { label: "anders", category: "Groups" },
      { label: "andreas", category: "Groups" },
      { label: "antal", category: "Groups" },
      { label: "annhhx10", category: "Events" },
      { label: "annk K12", category: "Events" },
      { label: "ann arbor, michigan", category: "Places" },
      { label: "anders andersson", category: "People" },
      { label: "andreas andersson", category: "People" },
      { label: "andreas johnson", category: "People" }
    ];


   $( "#header-search-query" ).catcomplete({
      delay: 0,
      source: search_data
    });
  });
*/

