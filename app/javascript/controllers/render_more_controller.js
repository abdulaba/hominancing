import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="render-more"
export default class extends Controller {
  static values = {
    nextPage: Number
  }

  static targets = ["recordContainer"]

  update() {
    const url = `./records?query=${this.nextPageValue}`;
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(res => res.text())
      .then((res) => {
        this.recordContainerTarget.innerHTML += "<hr>";
        this.recordContainerTarget.innerHTML += res;
        this.nextPageValue -= 1;
      });
  }
}
