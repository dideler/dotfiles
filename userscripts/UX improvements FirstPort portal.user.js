// ==UserScript==
// @name        UX improvements FirstPort portal
// @author      dideler
// @include     https://firstport.creatio.com/*
// @run-at      document-end
// ==/UserScript==

(function() {
  'use strict';

  function currentPage() {
    const page = document.querySelector('.selected button').textContent.trim();
    switch (page) {
      case "Home":
      case "Finances":
      case "Documents":
      case "Repairs":
      case "Cases":
      case "News":
      case "Help":
        return page;
      default:
        throw new Error(`Unknown page: ${page}`);
    }
  }

  const actionItems = [
    {
      id: 1,
      desc: "All pages: Resize main grid layout",
      status: "pending",
      selector: 'crt-grid[layout-config-column="3"][layout-config-col-span="8"]',
      modifier: (element) => {
        const newStyle = element.getAttribute('style')
          .replace('grid-column-start: 3', 'grid-column-start: 0')
          .replace('grid-column-end: span 8', 'grid-column-end: span 12');
        element.setAttribute('style', newStyle);
        return true;
      },
    },
    {
      id: 2,
      desc: "Repairs page: Resize Description column",
      status: "pending",
      selector: '[data-item-marker="Description column"]',
      modifier: (element) => {
        if (currentPage() === "Repairs") {
          element.style.width = '500px';
          return true;
        }
        return false;
      },
    },
    {
      id: 3,
      desc: "Finances page: Resize Description column",
      status: "pending",
      selector: '[data-item-marker="Description column"]',
      modifier: (element) => {
        if (currentPage() === "Finances") {
          element.style.width = '500px';
          return true;
        }
        return false;
      },
    },
    {
      id: 4,
      desc: "Documents page: Resize Title column",
      status: "pending",
      selector: '[data-item-marker="Title column"]',
      modifier: (element) => {
        if (currentPage() === "Documents") {
          element.style.width = '600px';
          return true;
        }
        return false;
      },
    },
    {
      id: 5,
      desc: "Cases page: Resize Category column",
      status: "pending",
      selector: '[data-item-marker="Category column"]',
      modifier: (element) => {
        if (currentPage() === "Cases") {
          element.style.width = '400px';
          return true;
        }
        return false;
      },
    },
    // TODO: Sortable table columns
  ];

  const isItemPending = (item) => item.status === "pending";
  const isItemCompleted = (item) => item.status === "completed";

  const markAsCompleted = (id) => {
    const item = actionItems.find(item => item.id === id);
    if (item) {
      item.status = "completed";
    }
  };

  function modifyItems() {
    const pendingItems = actionItems.filter(isItemPending);
    console.log('Checking items to modify. Remaining:', pendingItems.length);

    pendingItems.forEach(({ id, desc, selector, modifier }) => {
      console.debug('Checking action:', desc);

      const element = document.querySelector(selector);

      if (element) {
        const isModified = modifier(element);
        if (isModified) {
          console.log('Action completed:', desc);
          markAsCompleted(id);
        } else {
          console.debug('Element found with selector but not modified for action:', desc);
        }
      } else {
        console.debug('Element not found for action:', desc);
      }
    });

    if (actionItems.every(isItemCompleted)) {
      clearInterval(pollingInterval);
      console.log('Polling stopped, all items modified');
    }
  }

  console.log('Begin polling for items to modify. Remaining:', actionItems.length);
  const pollingInterval = setInterval(modifyItems, 2000);
})();
