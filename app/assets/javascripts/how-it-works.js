var HowItWorks = {

  tabs : ['upload', 'convert', 'view'],
  activeTab : null,

  setTabListeners : function() {
    $.each(this.tabs, function(i, tab) {
      $('.nav-bar a.' + tab).bind('click', function(e) {
        HowItWorks.activateTab(tab);
        e.preventDefault();
      });
    });
  },

  activate : function(tabClass) { 
    $(tabClass).addClass('active');
  },

  deactivate : function(tabClass) { 
    $(tabClass).removeClass('active');
  },

  activateTab : function(newTab) {
    if(this.activeTab === newTab) {
      return;
    }else {
      this.activeTab = newTab;
    }
    /* Make newTab active and remove active class from all the others tabs */
    $.each(this.tabs, function(i, tab) {
      (tab === newTab) ? HowItWorks.activate('.' + newTab) : HowItWorks.deactivate('.' + tab);
    }); 

    /* Show text of newTab */
    HowItWorks.showDescription(newTab);
  },

  showDescription : function(newTab) {
    if(!$('.description.' + newTab).is(':visible')) {
      $('.description:visible').fadeOut(200, function() {
        $('.description.' + newTab).fadeIn(200);
      });
    }
  },

  setImageListeners : function() {
    $('.d-image').click(function(e) {
      var tabClass = this.id.replace('image-', '');
      HowItWorks.activateTab(tabClass);
      return false;
    });
  }
}

$(function() { 
    HowItWorks.setTabListeners();
    HowItWorks.setImageListeners();
});

