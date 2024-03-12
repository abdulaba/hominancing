import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="render-more"
export default class extends Controller {
  static values = {
    nextPage: Number,
    year: Number,
    open: Boolean
  }

  static targets = ["recordContainer", "showMore", "openModal"]

  connect() {
    if (this.openValue) this.openModalTarget.click();
  }

  update() {
    const months = {
      0: "Enero",
      1: "Febrero",
      2: "Marzo",
      3: "Abril",
      4: "Mayo",
      5: "Junio",
      6: "Julio",
      7: "Agosto",
      8: "Septiembre",
      9: "Octubre",
      10: "Noviembre",
      11: "Diciembre"
    }

    const url = `./records?month=${this.nextPageValue}&year=${this.yearValue}`;
    fetch(url, { headers: { 'Accept': 'text/plain' } })
      .then(res => res.text())
      .then((data) => {
        this.showMoreTarget.remove()
        const h2 = document.createElement("h2");
        h2.innerText = months[this.nextPageValue - 1]
        this.recordContainerTarget.append(h2);
        this.recordContainerTarget.innerHTML += "<hr>";
        this.recordContainerTarget.innerHTML += data;
        if (this.nextPageValue - 1 < 1) {
          this.nextPageValue = 12;
          this.yearValue -= 1;
        } else {
          this.nextPageValue -= 1;
        }
      });
  }
}
