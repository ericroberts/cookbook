import Fraction from "fraction.js";

document.addEventListener('DOMContentLoaded', (event) => {
  const multiplierInput = document.querySelector("#multiplier");

  if (multiplierInput) {
    let multiplier: number;
    if (multiplierInput instanceof HTMLInputElement) {
      multiplier = parseFloat(multiplierInput.value);
    } else {
      throw new Error("No multiplier input element found");
    }

    multiplierInput.addEventListener("change", (event) => {
      if (event.target instanceof HTMLInputElement) {
        updateQuantities(parseFloat(event.target.value));
      }
    });

    updateQuantities(multiplier);
  }
});

const updateQuantities = (multiplier: number) => {
  const amounts = document.querySelectorAll(".amount");
  amounts.forEach((el) => {
    if (el instanceof HTMLElement) {
      let quantity: number;
      if (el.dataset.quantity) {
        quantity = parseFloat(el.dataset.quantity) * multiplier;
      } else {
        throw new Error("no quantity");
      }
      const unit = el.dataset.unit;
      el.innerHTML = formatAmount(quantity, unit);
    }
  });
};

const formatAmount = (quantity: number, unit: string | undefined) => {
  const fraction = new Fraction(quantity);
  const formattedFraction = fraction.toFraction(true);

  if (unit) {
    return `${formattedFraction} ${unit}`;
  } else {
    return `${formattedFraction}`
  }
}
