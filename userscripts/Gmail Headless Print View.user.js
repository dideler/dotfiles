// ==UserScript==
// @name        Gmail Headless Print View
// @description Removes the Gmail header from emails in print view
// @version     1.0
// @author      dideler
// @match       https://mail.google.com/mail/*&view=pt&*
// @run-at      document-end
// @compatible  chrome
// @compatible  firefox
// @compatible  opera
// @compatible  safari
// @compatible  edge
// ==/UserScript==

(function () {
  "use strict";

  function removeGmailHeader() {
    var firstTable = document.querySelector("table");
    if (firstTable) {
      firstTable.remove();
      console.log("Removed Gmail header from print view");
    }
  }

  removeGmailHeader();
})();