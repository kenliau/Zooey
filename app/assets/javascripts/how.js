var How = {

  tabs : ['upload', 'convert', 'view'],
  activeTab : null,

  setTabListeners : function() {
    $.each(this.tabs, function(i, tab) {
      $('.nav-bar a.' + tab).bind('click', function(e) {
        How.clickTab(tab);
        e.preventDefault();
      })
    })  
  },

  clickTab : function(tab) {
    console.log('clicked ' + tab);
    this.activateTab(tab);
/*    var newUrl = document.location.pathname.replace(/\/(how.*)/, '/how/' + tab)
    if (document.location.pathname != newUrl) {
      document.location.href = document.location.href.replace(/\/(how.*)/, '/how/' + tab);
    }
*/
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
      (tab === newTab) ? How.activate('.' + newTab) : How.deactivate('.' + tab);
    }); 

    /* Show text of newTab */
    How.showDescription(newTab)
  },

  showDescription : function(newTab) {
    if(!$('.description.' + newTab).is(':visible')) {
      $('.description:visible').fadeOut(200, function() {
        $('.description.' + newTab).fadeIn(200)
      })
    } 
  },

  setImageListeners : function() {



  }
 
}






$(function() { 
    How.setTabListeners();
    How.setImageListeners();
});

