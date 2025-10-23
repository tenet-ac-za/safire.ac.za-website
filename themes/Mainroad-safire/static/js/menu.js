'use strict';

(() => {
	const menuBtn = document.querySelector('.menu__btn');
	const menu = document.querySelector('.menu__list');

	const toggleMenu = function() {
		menu.classList.toggle('menu__list--active');
		menu.classList.toggle('menu__list--transition');
		this.classList.toggle('menu__btn--active');
		this.setAttribute(
			'aria-expanded',
			this.getAttribute('aria-expanded') === 'true' ? 'false' : 'true'
		);
	};

	const removeMenuTransition = function() {
		this.classList.remove('menu__list--transition');
	};

	if (menuBtn && menu) {
		menuBtn.addEventListener('click', toggleMenu, false);
		menu.addEventListener('transitionend', removeMenuTransition, false);
	}

	// Handle nested menu interactions for mobile
	const parentItems = document.querySelectorAll('.menu__item--has-children');

	const isMobile = () => window.getComputedStyle(menuBtn).display !== 'none';

	parentItems.forEach((item) => {
		const link = item.querySelector('.menu__link');

		// For mobile: add click handler to toggle submenu
		if (link) {
			link.addEventListener('click', (e) => {
				// Only handle click for mobile (when menu button is visible)
				if (isMobile()) {
					e.preventDefault();
					item.classList.toggle('menu__item--expanded');
				}
			});
		}

		// For desktop: ensure proper hover behavior
		item.addEventListener('mouseenter', () => {
			if (!isMobile()) {
				item.classList.add('menu__item--hover');
			}
		});

		item.addEventListener('mouseleave', () => {
			if (!isMobile()) {
				item.classList.remove('menu__item--hover');
			}
		});
	});

	// Close submenus when clicking outside
	document.addEventListener('click', (e) => {
		if (!e.target.closest('.menu')) {
			parentItems.forEach((item) => {
				item.classList.remove('menu__item--expanded');
			});
		}
	});
})();
