// function delayedRefresh() {
//  setTimeout( "refresh()", 1800*1000 );
//  }
// 
// function refresh() {
//  history.go(0);
//  }
 
function selectTab(event, tabName) {
 var i;
 var x = document.getElementsByClassName("selectableTabContent");
 var tablinks = document.getElementsByClassName("selectableTabButton");
 for (i = 0; i < x.length; i++) {
  x[i].style.display = "none";
  }
 for (i = 0; i < x.length; i++) {
  tablinks[i].id = "";
  }
 document.getElementById(tabName).style.display = "block";
 event.currentTarget.id = "selected";
 }

// https://stackoverflow.com/questions/17591447/how-to-reload-current-page-without-losing-any-form-data
// http://www.uitrick.com/javascript/how-to-keep-a-global-variable-alive-even-after-page-refresh-javascript/
// https://blog.udemy.com/javascript-page-refresh/

// localStorage.setItem('bgcolor', document.getElementById('bgcolor').value);
// localStorage.getItem('bgcolor');

// https://stackoverflow.com/questions/5683087/chaining-getelementbyid
function getById(id, context) {
 var el = document.getElementById(id);
 return context.contains(el) ? el : null;
 }

function getByName(name, context) {
 var i;
 var x = document.getElementsByName(name);
 for (i = 0; i < x.length; i++) {
  if ((x[i].getAttribute('name') == name) && (context.contains(x[i]))) {
   return x[i];
   }
  }
 return null;
 }

/*
// Run on page load
window.onload = function() {
 if (typeof(Storage) !== "undefined") {
  // Code for localStorage/sessionStorage.
  var tabName = localStorage.getItem('navbar-selected');
  if (tabName == "undefined") { tabName = "IP_detected"; }
  var navbar = document.getElementById('navbar');
  var tab = getByName(tabName, navbar);
  var i;
  var x = document.getElementsByClassName("selectableTabContent");
  var tablinks = document.getElementsByClassName("selectableTabButton");

  for (i = 0; i < x.length; i++) {
   x[i].style.display = "none";
   }
  for (i = 0; i < x.length; i++) {
   tablinks[i].id = "";
   }

  document.getElementById(tabName).style.display = "block";
  tab.id = "selected";
  }
 else {
  // Sorry! No Web Storage support..
  }
 }

// Before refreshing the page, save the form data to sessionStorage
window.onbeforeunload = function() {
 if (typeof(Storage) !== "undefined") {
  // Code for localStorage/sessionStorage.
  // var navbar = document.getElementById('navbar');
  var selected = document.getElementById('selected'); // getById('selected', navbar);

  var tabName = selected.getAttribute('name');
  localStorage.setItem('navbar-selected', tabName);
  }
 else {
  // Sorry! No Web Storage support..
  }
 }
*/
