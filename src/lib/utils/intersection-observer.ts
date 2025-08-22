import { browser } from '$app/environment';

/**
 * Creates an intersection observer to detect when user is near the bottom of the page
 * This is used for triggering intelligent prefetching
 */
export function createScrollObserver(
	callback: () => void,
	threshold = 0.8
): {
	observe: (element: HTMLElement) => void;
	disconnect: () => void;
} {
	if (!browser) {
		return {
			observe: () => {},
			disconnect: () => {}
		};
	}

	const observer = new IntersectionObserver(
		(entries) => {
			entries.forEach((entry) => {
				if (entry.isIntersecting) {
					callback();
				}
			});
		},
		{
			rootMargin: `${(1 - threshold) * 100}% 0px 0px 0px`,
			threshold: 0
		}
	);

	return {
		observe: (element: HTMLElement) => observer.observe(element),
		disconnect: () => observer.disconnect()
	};
}

/**
 * Debounce function to limit how often a function can be called
 */
export function debounce<T extends (...args: any[]) => void>(
	func: T,
	wait: number
): T {
	let timeout: ReturnType<typeof setTimeout>;
	return ((...args: any[]) => {
		clearTimeout(timeout);
		timeout = setTimeout(() => func.apply(null, args), wait);
	}) as T;
}

/**
 * Throttle function to limit how often a function can be called
 */
export function throttle<T extends (...args: any[]) => void>(
	func: T,
	wait: number
): T {
	let inThrottle: boolean;
	return ((...args: any[]) => {
		if (!inThrottle) {
			func.apply(null, args);
			inThrottle = true;
			setTimeout(() => inThrottle = false, wait);
		}
	}) as T;
}
