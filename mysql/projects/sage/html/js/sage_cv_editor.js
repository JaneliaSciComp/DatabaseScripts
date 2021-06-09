var url = '/cgi-bin/sage_cv_editor_ajax.cgi';


//*****************************************************************************
//*  Query screen routines                                                    *
//*****************************************************************************

function displayCV () {
  new Ajax.Updater('cvarea',url, {
    method: 'post',
    parameters: {operation: 'list_cv',
                 database:  $F('_database')},
    });
  return false;
}

function displayCVTerms (new_cv) {
  if (!new_cv) {
    new_cv = $F('cv');
  }
  if ($F('cv') == '') {
    $('cvterm').update('');
    if ($F('_modify') == 1)
      $('add_cvterm').hide();
    return;
  }
  new Ajax.Updater('cvterm',url, {
    onCreate: function() {$('loading').show();},
    onComplete: loadDone,
    method: 'post',
    parameters: {operation: 'query_cv',
                 admin:     $F('_admin'),
                 modify:    $F('_modify'),
                 database:  $F('_database'),
                 id:        new_cv},
    });
  new Ajax.Updater('relationship_vw',url, {
    onCreate: function() {$('loading').show();},
    onComplete: loadDone,
    method: 'post',
    parameters: {operation: 'display_relationship',
                 admin:     $F('_admin'),
                 modify:    $F('_modify'),
                 database:  $F('_database'),
                 id:        new_cv},
    });
  new Ajax.Updater('r_menu',url, {
    onCreate: function() {$('loading').show();},
    onComplete: loadDone,
    method: 'post',
    parameters: {operation: 'term_relationship',
                 admin:     $F('_admin'),
                 modify:    $F('_modify'),
                 database:  $F('_database'),
                 id:        new_cv},
    });
  new Ajax.Updater('r_cv_menu',url, {
    onCreate: function() {$('loading').show();},
    onComplete: loadDone,
    method: 'post',
    parameters: {operation: 'cv_relationship',
                 admin:     $F('_admin'),
                 modify:    $F('_modify'),
                 database:  $F('_database'),
                 id:        new_cv},
    });
  return false;
}
function UpdateRelationshipCv(){
 cv = $F('relationship_cv_menu');
 new Ajax.Updater('r_cv_term_menu',url, {
    onComplete: loadDone,
    method: 'post',
    parameters: {operation: 'cv_term_relationship',
                 admin:     $F('_admin'),
                 modify:    $F('_modify'),
                 database:  $F('_database'),
                 id:        cv},
    });
   var button = $('add_relationship');
   button['enable']();
  return false;

}

function deleteData (iid) {
  var answer = confirm('Do you want to delete this CV term?');
  if (!answer) {
    displayCVTerms();
    return false;
  }
  new Ajax.Request(url, {
      method: 'post',
      parameters: {operation: 'delete_cvterm',
                   database:  $F('_database'),
                   id:        iid},
      onSuccess: function(transport) {
        alert(transport.responseText);
        displayCVTerms();
      },
      onFailure: function(transport) {
        alert(transport.responseText);
      }
    });
}
function deleteRelationship (iid) {
  var answer = confirm('Do you want to delete this CV term relationship?');
  if (!answer) {
    displayCVTerms();
    return false;
  }
  new Ajax.Request(url, {
      method: 'post',
      parameters: {operation: 'delete_relationship',
                   database:  $F('_database'),
                   id:        iid},
      onSuccess: function(transport) {
        alert(transport.responseText);
        displayCVTerms();
      },
      onFailure: function(transport) {
        alert(transport.responseText);
      }
    });
}

function changeData (iid,display,cv) {
  var answer = confirm('Do you want to change the ' + display + '?');
  if (!answer) {
    displayCVTerms();
    return false;
  }
  if (cv) {
    op = 'update_cv'
  }
  else {
    op = 'update_cvterm';
  }
  new Ajax.Request(url, {
      method: 'post',
      parameters: {operation: op,
                   database:  $F('_database'),
                   id:        iid,
                   value:     $F(iid)},
      onSuccess: function(transport) {
        alert('Changed ' + display);
        displayCVTerms();
      },
      onFailure: function(transport) {
        alert(transport.responseText);
      }
    });
}

loadDone = function() {
  if ($F('_modify') == 1) {
  new Ajax.InPlaceEditor('cv_display',url,{
        callback: function(form,value) {
          return 'operation=update_cv&database=' + $F('_database') + '&id='
                 + $F('_cvid') + '__display_name&value=' + escape(value) },
          rows:1,cols:40});
  new Ajax.InPlaceEditor('cv_definition',url,{
        callback: function(form,value) {
          return 'operation=update_cv&database=' + $F('_database') + '&id='
                 + $F('_cvid') + '__definition&value=' + escape(value) },
          rows:1,cols:40});
  $$('span').each(function(item) {
    if ($(item).id) {
      new Ajax.InPlaceEditor($(item).id,url,{
        callback: function(form,value) {
          return 'operation=update_cvterm&database=' + $F('_database') + '&id='
                 + $(item).id + '&value=' + escape(value) },
          rows:1,cols:40});
    }
  });
  }
  $('loading').hide();
  if ($F('_modify') == 1)
    $('add_cvterm').show();
    $('add_cvterm_relationship').show();
  $('name').update('');
  $('display_name').update('');
  $('definition').update('');
}

function addCVTerm() {
  if ($F('name') == '') {
    return false;
  }
  new Ajax.Request(url, {
      method: 'post',
      parameters: {operation:    'add_cvterm',
                   database:     $F('_database'),
                   id:           $F('cv'),
                   name:         $F('name'),
                   is_current:   $F('is_current'),
                   display_name: $F('display_name'),
                   data_type:    $F('data_type'),
                   definition:   $F('definition')},
      onSuccess: function(transport) {
        alert(transport.responseText);
        displayCVTerms();
        $F('name') = '';
        $F('display_name') = '';
        $F('definition') = '';
      },
      onFailure: function(transport) {
        alert(transport.responseText);
      }
    });
  return false;
}
function addRelationship() {
  if ($F('relationship_cv_term_menu') == '') {
    return false;
  }
  if ($F('relationship_cv_term_menu') == $F('r_object')){
    alert('CV Term and Object CV Term cannot be the same CV Term.');
    return false;
  }
  new Ajax.Request(url, {
      method: 'post',
      parameters: {operation:    'add_cvterm_relationship',
                   database:     $F('_database'),
                   id:           $F('relationship_cv_term_menu'),
                   type:         $F('r_type'),
                   object:       $F('r_object')
      },
      onSuccess: function(transport) {
        alert(transport.responseText);
        displayCVTerms();
      },
      onFailure: function(transport) {
        alert(transport.responseText);
      }
    });
  return false;
}
var hidden = 0;
function hideBoring(){
  if (hidden){
   $$('.is_part').each(
     function (e) {
        e.show(); 
     } 
   );
  }
  else{
   $$('.is_part').each(
     function (e) {
        e.hide(); 
     } 
   );
  }
  hidden = 1 - hidden;

  return false;
}

