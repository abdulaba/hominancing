import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="render-more"
export default class extends Controller {
  static values = {
    nextPage: Number
  }

  connect() {
    console.log(this.nextPageValue);
  }

  update() {
    const url = `./records?query=${this.nextPageValue}`;
    fetch(url).then(res => res.json()).then(res => console.log(res))
  }
}
