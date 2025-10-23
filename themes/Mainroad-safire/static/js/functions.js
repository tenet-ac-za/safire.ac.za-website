'use strict';

document.addEventListener('DOMContentLoaded', () => {
	const elements = document.querySelectorAll('.tenet-obfusticate');
	elements.forEach((element) => {
		const href = element.dataset.href;
		if (href) {
			element.setAttribute('href', atob(href));
		}
		if (!element.classList.contains('tenet-cleartext')) {
			const text = element.textContent;
			element.innerHTML = atob(text);
		}
		const css = element.dataset.class;
		if (css) {
			element.classList.add(css);
		}
	});
});
