
document.addEventListener("DOMContentLoaded", function() {
	const tabs = document.querySelectorAll(".selectableTabButton");
	const contents = document.querySelectorAll(".selectableTabContent");

	function selectTab(tabName, clickedTab) {
		// Hide all
		contents.forEach(c => c.style.display = "none");
		tabs.forEach(t => t.id = "");

		// Show selected tab
		const target = document.getElementById(tabName);
		if (target) target.style.display = "block";

		// Mark the selected button
		clickedTab.id = "selected";
	}

	// Attach listeners
	tabs.forEach(tab => {
		tab.addEventListener("click", function() {
			selectTab(this.dataset.tab, this);
		});
	});

	// Display the first one by default
	if (tabs.length > 0) {
		selectTab(tabs[0].dataset.tab, tabs[0]);
	}
});
