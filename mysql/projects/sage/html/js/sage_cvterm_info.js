var AJAX_URL = '/sage_ajax.php';


//*****************************************************************************
//*  Query screen general routines                                            *
//*****************************************************************************

function ajaxInitialize () {
  // Initialize autocompletion
  new Ajax.Autocompleter('cvterm','cvterm_autocomplete',
                         AJAX_URL,
                         {parameters: 'query=cvterm&formvar=cvterm',
                          indicator:  'cvterm_loading',
                          minChars:   3,
                         });
  return false;
}
