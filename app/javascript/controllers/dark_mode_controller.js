import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['rootTag'];

  connect() {
    console.log('Connected to dark mode controller');
    this.applyDarkMode();
    this.applySlimSelectDarkModeWithRAF();
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
    this.applySlimSelectDarkModeWithRAF();
  }

  setLightMode() {
    this.rootTagTarget.classList.remove('dark');
    this.rootTagTarget.classList.add('light');
    localStorage.removeItem('darkModeEnabled');
    this.applySlimSelectDarkModeWithRAF();
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

    if (slimSelectMain && slimSelectContent) {
      elementsToAlter.forEach(element => {
        if (darkModeEnabled) {
          element.classList.remove('light');
          element.classList.add('dark');
        } else {
          element.classList.remove('dark');
          element.classList.add('light');
        }
      });
    }
  }

  applySlimSelectDarkModeWithRAF() {
    requestAnimationFrame(() => {
      this.applySlimSelectDarkMode();
    });
  }
}
