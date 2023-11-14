import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['rootTag'];

  connect() {
    console.log('Connected to dark mode controller');
    this.applyDarkMode();
    this.applySlimSelectDarkMode();
    this.addDarkModeChangeListener();
  }

  toggleDarkMode() {
    if (this.rootTagTarget.classList.contains('dark')) {
      this.setLightMode();
    } else {
      this.setDarkMode();
    }
  }

  setDarkMode() {
    this.rootTagTarget.classList.remove('light');
    this.rootTagTarget.classList.add('dark');
    localStorage.setItem('darkModeEnabled', 'true');
    this.applySlimSelectDarkMode();
  }

  setLightMode() {
    this.rootTagTarget.classList.remove('dark');
    this.rootTagTarget.classList.add('light');
    localStorage.removeItem('darkModeEnabled');
    this.applySlimSelectDarkMode();
  }

  applyDarkMode() {
    const darkModeEnabled = localStorage.getItem('darkModeEnabled');
    if (darkModeEnabled === 'true') {
      this.setDarkMode();
    } else {
      this.setLightMode();
    }
  }

  applySlimSelectDarkMode() {
    const slimSelectMain = this.rootTagTarget.querySelector('.ss-main');
    const slimSelectContent = this.rootTagTarget.querySelector('.ss-content');
    const elementsToAlter = [slimSelectContent, slimSelectMain];

    const darkModeEnabled = localStorage.getItem('darkModeEnabled') === 'true';

    elementsToAlter.forEach(element => {
      element.classList.remove('light', 'dark');
      element.classList.add(darkModeEnabled ? 'dark' : 'light');
    });
  }

  toggleDarkModeButtonClick() {
    const darkModeToggleBtn = document.getElementById('darkModeToggleBtn');
    if (darkModeToggleBtn) {
      darkModeToggleBtn.addEventListener('click', () => {
        this.toggleDarkMode();
      });
    }
  }

  addDarkModeChangeListener() {
    window.addEventListener('storage', () => {
      this.applyDarkMode();
    });
  }
}
