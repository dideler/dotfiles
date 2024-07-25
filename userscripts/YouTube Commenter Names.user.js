// ==UserScript==
// @name         YouTube Commenter Names
// @version      1.6.3
// @description  Make YouTube display the names of commenters instead of their handles.
// @author       Lumynous
// @license      MIT
// @match        https://www.youtube.com/*
// @match        https://studio.youtube.com/*
// @noframes
// @downloadURL  https://gist.github.com/lumynou5/74bcbab54cd9d8fcd3c873fffbac5d3d/raw/youtube-commenter-names.user.js
// ==/UserScript==

'use strict';

const watchElm = (function () {
  const elmObserver = new MutationObserver(elmObserverCallback);
  elmObserver.observe(document, {childList: true, subtree: true});
  const callbacks = new Set();

  function elmObserverCallback(mutations) {
    for (const {callback, selector} of callbacks) {
      for (const mutation of mutations) {
        for (const node of mutation.addedNodes) {
          if (node.nodeType !== Node.ELEMENT_NODE) continue;
          if (node.matches(selector)) {
            callback(node);
          }
          for (const x of node.querySelectorAll(selector)) {
            callback(x);
          }
        }
      }
    }
  }

  function elmCallback(observer, observerOption, elmAction, textAction, elm) {
    const node = elmAction(elm);
    if (node) {
      textAction(node);
      observer.observe(node, observerOption);
    }
  }

  function publicFunctionImpl(observerOption, selector, elmAction, textAction) {
    const observer = new MutationObserver((mutations) => {
      for (const mutation of mutations) {
        textAction(mutation.target);
      }
    });
    const callback = elmCallback.bind(null, observer, observerOption, elmAction, textAction);
    for (const elm of document.querySelectorAll(selector)) {
      callback(elm);
    }
    callbacks.add({callback, selector});
  }

  return {
    attributes: publicFunctionImpl.bind(null, {attributes: true}),
    characterData: publicFunctionImpl.bind(null, {characterData: true}),
  };
})();

function fetchInternalApi(endpoint, body) {
  return fetch(
    `https://www.youtube.com/youtubei/v1/${endpoint}?key=AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8`,
    {
      method: 'POST',
      body: JSON.stringify({
        context: {client: {clientName: 'WEB', clientVersion: '2.20240411.01.00'}},
        ...body,
      }),
    }
  )
    .then((response) => response.json());
}

const getChannelId = (function () {
  const channelIds = new Map();

  return function (url) {
    let res = channelIds.get(url);
    if (res === undefined) {
      // Fetching `/navigation/resolve_url` endpoint for channel IDs was introduced in 1.5.10.
      // Testing shows this approach has a better performance (both time cost and data used) than
      // requesting channel pages, even though it requests twice for each channel, while regex is
      // slow and channel pages are huge.
      res = fetchInternalApi('navigation/resolve_url', {url})
        .then((json) => {
          if (json.endpoint.browseEndpoint) {
            return json.endpoint.browseEndpoint.browseId;
          } else {
            // Workaround: Some channels such as @rayduenglish behave strange.  Normally GETing
            // channel pages result 303 and redirect to `/rayduenglish` for example; the internal
            // API responses similarly, the workaround is to resolve twice.  However, some are
            // impossible to resolve correctly; for example, requesting `/@Konata` redirected to
            // `/user/Konata`, and `/user/Konata` leads 404.  This is probably a bug of YouTube.
            return fetchInternalApi('navigation/resolve_url', json.endpoint.urlEndpoint)
              .then((json) => json.endpoint.browseEndpoint.browseId);
          }
        });
      channelIds.set(url, res);
    }
    return res;
  };
})();

const getChannelName = (function () {
  const channelNames = new Map();

  return function (id) {
    let res = channelNames.get(id);
    if (res === undefined) {
      res = fetchInternalApi('browse', {browseId: id})
        .then((json) => json.metadata.channelMetadataRenderer.title);
      channelNames.set(id, res);
    }
    return res;
  };
})();

function replaceText(node, text) {
  if (node.textContent === text) return;
  node.textContent = text;
}


if (location.hostname === 'www.youtube.com') {
  // Mentions in titles.
  watchElm.attributes('#title.ytd-watch-metadata a.yt-simple-endpoint', (elm) => {
    if (elm.pathname[1] !== '@') return; // Skip hashtags.
    return elm;
  }, (elm) =>
    getChannelName(elm.data.browseEndpoint.browseId)
      .then(replaceText.bind(null, elm))
  );

  // Commenters.
  watchElm.attributes('#author-text.ytd-comment-view-model:not([hidden])', (elm) => {
    return elm;
  }, (elm) =>
    getChannelName(elm.data.browseEndpoint.browseId)
      .then(replaceText.bind(null, elm.firstElementChild.firstChild))
  );
  watchElm.attributes('#name.ytd-author-comment-badge-renderer', (elm) => {
    return elm;
  }, (elm) =>
    getChannelName(elm.data.browseEndpoint.browseId)
      .then(replaceText.bind(null, elm.querySelector('#text').firstChild))
  );

  // Mentions in comments.
  watchElm.attributes('#content-text.ytd-comment-view-model a', (elm) => {
    if (elm.textContent.trim()[0] !== '@') return; // Skip anchors such as timestamps.
    return elm;
  }, (elm) =>
    getChannelName(elm.href.slice(elm.href.lastIndexOf('/') + 1))
      .then((name) => replaceText(elm.firstChild, `\xA0${name}\xA0`))
  );
} else {
  watchElm.attributes('#name.ytcp-comment:not([hidden])', (elm) => {
    return elm;
  }, (elm) =>
    getChannelId(elm.href)
      .then(getChannelName)
      .then((name) => void (elm.firstElementChild.firstChild.textContent = name))
  );
  watchElm.attributes('#badge-name.ytcp-author-comment-badge', (elm) => {
    return elm;
  }, (elm) =>
    getChannelId(elm.href)
      .then(getChannelName)
      .then((name) => void (elm.firstElementChild.firstChild.textContent = name))
  );
}
