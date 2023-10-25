import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['rootTag'];

  connect() {
    console.log('Connected to dark mode controller');
    this.applyDarkMode();
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
  }

  setLightMode() {
    this.rootTagTarget.classList.remove('dark');
    this.rootTagTarget.classList.add('light');
    localStorage.removeItem('darkModeEnabled');
  }

  applyDarkMode() {
    const darkModeEnabled = localStorage.getItem('darkModeEnabled');
    if (darkModeEnabled === 'true') {
      this.setDarkMode();
    } else {
      this.setLightMode();
    }
  }
}
