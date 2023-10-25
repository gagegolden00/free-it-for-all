import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['rootTag', 'sunSvg', 'moonSvg'];

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
    this.moonSvgTarget.classList.add('hidden');
    this.sunSvgTarget.classList.remove('hidden');
    this.setLocalStorage('darkModeEnabled', 'true');
    this.setLocalStorage('currentIcon', 'sunSvg'); 
  }

  setLightMode() {
    this.rootTagTarget.classList.remove('dark');
    this.rootTagTarget.classList.add('light');
    this.moonSvgTarget.classList.remove('hidden');
    this.sunSvgTarget.classList.add('hidden');
    this.removeLocalStorage('darkModeEnabled');
    this.setLocalStorage('currentIcon', 'moonSvg'); 
  }

  applyDarkMode() {
    const darkModeEnabled = this.getLocalStorage('darkModeEnabled');
    if (darkModeEnabled === 'true') {
      this.setDarkMode();
    } else {
      this.setLightMode();
    }
  }

  setLocalStorage(key, value) {
    localStorage.setItem(key, value);
  }

  removeLocalStorage(key) {
    localStorage.removeItem(key);
  }

  getLocalStorage(key) {
    return localStorage.getItem(key);
  }
}
