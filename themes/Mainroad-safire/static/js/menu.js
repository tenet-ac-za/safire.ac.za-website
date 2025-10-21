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

	// Handle nested menu interactions for mobile
	var parentItems = document.querySelectorAll('.menu__item--has-children');

	parentItems.forEach(function(item) {
		var link = item.querySelector('.menu__link');

		// For mobile: add click handler to toggle submenu
		if (link) {
			link.addEventListener('click', function(e) {
				// Only handle click for mobile (when menu button is visible)
				if (window.getComputedStyle(menuBtn).display !== 'none') {
					e.preventDefault();
					item.classList.toggle('menu__item--expanded');
				}
			});
		}

		// For desktop: ensure proper hover behavior
		item.addEventListener('mouseenter', function() {
			if (window.getComputedStyle(menuBtn).display === 'none') {
				item.classList.add('menu__item--hover');
			}
		});

		item.addEventListener('mouseleave', function() {
			if (window.getComputedStyle(menuBtn).display === 'none') {
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
}(document, window));
