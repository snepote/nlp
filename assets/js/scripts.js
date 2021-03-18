function toggleDarkMode() {
  var element = document.body;
  element.classList.toggle("dark-mode");
}

document.addEventListener("DOMContentLoaded", function(event) {
  toggleDarkMode();
});
