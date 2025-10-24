'use strict';

(function iifeMenu(document, window, undefined) {
	var menuBtn = document.querySelector('.menu__btn');
	var	menu = document.querySelector('.menu__list');

	function toggleMenu() {
		menu.classList.toggle('menu__list--active');
		menu.classList.toggle('menu__list--transition');
		this.classList.toggle('menu__btn--active');
		this.setAttribute(
			'aria-expanded',
			this.getAttribute('aria-expanded') === 'true' ? 'false' : 'true'
		);
	}

	function removeMenuTransition() {
		this.classList.remove('menu__list--transition');
	}

	if (menuBtn && menu) {
		menuBtn.addEventListener('click', toggleMenu, false);
		menu.addEventListener('transitionend', removeMenuTransition, false);
	}

	/*
	 * Additional functionality added in derivative theme
	 */

	function isMobile() {
		return window.getComputedStyle(menuBtn).display !== 'none';
	}

	// Handle nested menu interactions for mobile
	var parentItems = document.querySelectorAll('.menu__item--has-children');
	parentItems.forEach(function(item) {
		var link = item.querySelector('.menu__link');

		// For mobile: add click handler to toggle submenu
		if (link) {
			link.addEventListener('click', function(e) {
				// Only handle click for mobile (when menu button is visible)
				if (isMobile()) {
					e.preventDefault();
					item.classList.toggle('menu__item--expanded');
				}
			});
		}

		// For desktop: ensure proper hover behavior
		item.addEventListener('mouseenter', function() {
			if (!isMobile()) {
				item.classList.add('menu__item--hover');
			}
		});

		item.addEventListener('mouseleave', function() {
			if (!isMobile()) {
				item.classList.remove('menu__item--hover');
			}
		});
	});

	// Close submenus when clicking outside
	document.addEventListener('click', function(e) {
		if (!e.target.closest('.menu')) {
			parentItems.forEach(function(item) {
				item.classList.remove('menu__item--expanded');
			});
		}
	});

	/*
	 * Email obfuscation functionality (not strictly menu-related)
	 */
	var defusticate = document.querySelectorAll('.tenet-obfusticate');
	defusticate.forEach(function(element) {
		var href = element.dataset.href;
		if (href) {
			element.setAttribute('href', atob(href));
		}
		if (!element.classList.contains('tenet-cleartext')) {
			var text = element.textContent;
			element.innerHTML = atob(text);
		}
		var css = element.dataset.class;
		if (css) {
			element.classList.add(css);
		}
	});
}(document, window));
