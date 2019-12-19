document.addEventListener("DOMContentLoaded", function() {

  const bottomButtons = document.querySelectorAll(".uned-poll-button-container")
  const topButtons = document.querySelectorAll(".uned-poll-buttons-top-slider")

  topButtons.forEach(button => button.addEventListener('click', () => {
    buttonTop(event)
  }));

  bottomButtons.forEach(button => button.addEventListener('click', () => {
    buttonBottom(event)
  }));

  let extractId = function(e) {
      const stringNumber = e.target.id;
      const reg = /\d+/;
      const idNumber = stringNumber.match(reg)[0]
      const idNumberPrev = Number(idNumber) - 1
      const idNumberNext = Number(idNumber) + 1
      return {
        idNumber,
        idNumberPrev,
        idNumberNext
      }
  };

  function showContainerText(id) {
    const containerText = document.getElementById(`uned-poll-slider-content-text-${id}`)
    document.querySelectorAll(".uned-poll-slider-content").forEach(container => container.classList.add('is-hidden'))
    containerText.classList.remove('is-hidden')
  }

  function buttonTop(e) {

    bottomButtons.forEach(container => container.classList.add('is-disable'))
    bottomButtons.forEach(container => container.classList.remove('first-button', 'is-active-last', 'last-button'))

    topButtons.forEach(button => button.classList.remove('is-active-btn'))

    e.target.classList.add('is-active-btn');

    let {idNumber, idNumberPrev, idNumberNext} = extractId(e)

    const element = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
    const elementNext = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberNext}`)
    const elementPrev = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberPrev}`)

    if(e.target.id === 'uned-poll-button-top-1') {

      element.classList.remove('is-disable')
      elementNext.classList.remove('is-disable')
      element.classList.add('first-button')
      elementNext.classList.add('first-button')

    } else if (e.target.id === 'uned-poll-button-top-5') {

      element.classList.remove('is-disable')
      elementPrev.classList.remove('is-disable')
      element.classList.add('last-button')
      elementPrev.classList.add('is-active-last')

    } else {

      elementPrev.classList.remove('is-disable')
      elementNext.classList.remove('is-disable')
      elementPrev.classList.add('is-active-last')
    }

    showContainerText(idNumber)

  }

  function buttonBottom(e) {

    e.target.classList.remove('is-disable');
    let {idNumber, idNumberPrev, idNumberNext} = extractId(e)

    const buttonBottomActive = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumber}`)
    const buttonBottomActiveNext = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberNext}`)
    const buttonBottomActivePrev = document.getElementById(`uned-poll-buttons-bottom-slider-${idNumberPrev}`)

    topButtons.forEach(button => button.classList.remove('is-active-btn'))
    const buttonTop = document.getElementById(`uned-poll-button-top-${idNumber}`)
    buttonTop.classList.add('is-active-btn')

    bottomButtons.forEach(container => container.classList.add('is-disable'))
    bottomButtons.forEach(container => container.classList.remove('first-button', 'last-button'))

    if(e.target.classList.contains('is-active-last') && e.target.id !== 'uned-poll-buttons-bottom-slider-1') {

      bottomButtons.forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active-last')

    } else if(e.target.id === 'uned-poll-buttons-bottom-slider-1') {

      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActive.classList.add('first-button')
      buttonBottomActiveNext.classList.remove('is-disable')

    } else if(e.target.id === 'uned-poll-buttons-bottom-slider-5') {

      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active-last')
      buttonBottomActive.classList.add('last-button')

    } else {
      bottomButtons.forEach(button => button.classList.remove('is-active-last'))

      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
    }

    showContainerText(idNumber)
  }

  document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.addEventListener('click', () => {
    buttonInside(event)
  }));

  function buttonInside(e) {
    document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.classList.remove('is-active'))

    e.target.classList.add('is-active');

    let {idNumber, idNumberPrev, idNumberNext} = extractId(e)

    const buttonBottomActive = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber}`)
    const buttonBottomActiveNext = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberNext}`)
    const buttonBottomActivePrev = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberPrev}`)

    const containerText = document.getElementById(`uned-poll-participa-content-${idNumber}`)
    document.querySelectorAll(".uned-poll-slider-participa-content").forEach(container => container.classList.add('is-disable'))
    document.querySelectorAll(".uned-poll-slider-participa-content").forEach(container => container.classList.remove('is-active'))
    containerText.classList.remove('is-disable')
    containerText.classList.add('is-active')

    document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(container => container.classList.add('is-disable'))

    if(e.target.classList.contains('is-active-last') && e.target.id !== 'uned-poll-buttons-slider-participa-1') {

      document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')
      buttonBottomActiveNext.classList.add('is-active')

    } else if(e.target.id === 'uned-poll-buttons-slider-participa-1') {

      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActive.classList.add('is-active')
      buttonBottomActiveNext.classList.add('is-active')
      const buttonBottom = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber}`)
      const buttonBottomSibling = document.getElementById(`uned-poll-buttons-slider-participa-${idNumberNext}`)

      buttonBottom.classList.add('first-button')

    } else if(e.target.id === 'uned-poll-buttons-slider-participa-8') {

      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActive.classList.remove('is-disable')
      buttonBottomActive.classList.add('is-active')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')

      const buttonBottom = document.getElementById(`uned-poll-buttons-slider-participa-${idNumber}`)
      buttonBottom.classList.add('last-button')
    } else {
      document.querySelectorAll(".uned-poll-slider-participa-button-container").forEach(button => button.classList.remove('is-active-last'))
      buttonBottomActivePrev.classList.remove('is-disable')
      buttonBottomActivePrev.classList.add('is-active', 'is-active-last')
      buttonBottomActiveNext.classList.remove('is-disable')
      buttonBottomActiveNext.classList.add('is-active')
    }
  }
});
