//= require_tree .

var completeLinkTarget = function() {
  var links = document.getElementsByTagName('a');

  for (i = 0; i < links.length; i++) {
    var link = links[i];

    if (!link.getAttribute('href').match('^https?:') || link.getAttribute('target')) continue;

    link.setAttribute('target', '_blank');
  }
};

document.addEventListener('DOMContentLoaded', completeLinkTarget, false);
